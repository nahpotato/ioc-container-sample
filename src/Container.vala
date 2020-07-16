class Container : Object {

    private Gee.Map<Type, Type> _registered_types;

    public void register_type <K,V> ()
        requires (typeof (K).is_interface () || typeof (K).is_object ())
        requires (typeof (V).is_object ())
        requires (typeof (V).is_a (typeof (K)))
    {
        this.register_type_with_explicit_types (typeof (K), typeof (V));
    }

    public void register_type_with_explicit_types (Type key_type, Type value_type)
        requires (key_type.is_interface () || key_type.is_object ())
        requires (value_type.is_object ())
        requires (value_type.is_a (key_type))
    {
        if (this._registered_types == null) {
            this._registered_types = new Gee.HashMap<Type, Type> ();
        }

        this._registered_types[key_type] = value_type;
    }

    public T get_instance<T> () requires (typeof (T).is_object ()) {
        return this.get_instance_from_type (typeof (T));
    }

    public Object get_instance_from_type (Type type) requires (type.is_object ()) {
        if (this._registered_types == null) {
            return Object.@new (type);
        }

        var props = this.get_construct_properties (type);
        var names = this.get_matched_property_names (props);
        var values = this.get_matched_property_values (props);

        return Object.new_with_properties (type, names, values);
    }

    private (unowned ParamSpec)[] get_construct_properties (Type type)
        requires (type.is_object ())
    {
        var klass = (ObjectClass) type.class_ref ();
        var props = klass.list_properties ();
        (unowned ParamSpec)[] result = new (unowned ParamSpec)[0];

        for (var i = 0; i < props.length; i++) {
            if ((props[i].flags & ParamFlags.CONSTRUCT) != 0 ||
                (props[i].flags & ParamFlags.CONSTRUCT_ONLY) != 0)
            {
                result.resize (result.length + 1);
                result[result.length - 1] = props[i];
            }
        }

        return result;
    }

    private (unowned string)[] get_matched_property_names ((unowned ParamSpec)[] props) {
        (unowned string)[] names = new (unowned string)[0];

        for (var i = 0; i < props.length; i++) {
            foreach (var key_type in this._registered_types.keys) {
                if (props[i].value_type == key_type) {
                    names.resize (names.length + 1);
                    names[names.length - 1] = props[i].name;
                }
            }
        }

        return names;
    }

    private Value[] get_matched_property_values ((unowned ParamSpec)[] props) {
        Value[] values = new Value[0];

        for (var i  = 0; i < props.length; i++) {
            foreach (var registered_type in this._registered_types.entries) {
                if (props[i].value_type == registered_type.key) {
                    values.resize (values.length + 1);
                    var @value = Value (registered_type.value);
                    @value.set_object (this.get_instance_from_type (registered_type.value));
                    values[values.length - 1] = @value;
                }
            }
        }

        return values;
    }
}
