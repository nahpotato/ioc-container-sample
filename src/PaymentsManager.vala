class PaymentsManager : Object {

    public IPaymentsService service { get; construct; }

    public PaymentsManager (IPaymentsService service) {
        Object (
            service: service
        );
    }

    public void pay () requires (this.service != null) {
        message ("I'm going to pay");
        this.service.pay ();
    }
}
