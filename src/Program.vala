class Program : Object {

    public static void main () {
        var container = new Container ();
        container.register_type<IPaymentsService, PayPalService> ();

        var payments_manager = container.get_instance<PaymentsManager> ();
        payments_manager.pay ();
    }
}
