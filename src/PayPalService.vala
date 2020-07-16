class PayPalService : Object, IPaymentsService {

    public void pay () {
        this.pay_with_paypal ();
    }

    public void pay_with_paypal () {
        message ("I'm paying with PayPal");
    }
}
