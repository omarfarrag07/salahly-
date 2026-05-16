class SendOfferRequest {
  final int price;
  final int offerId;

  SendOfferRequest({
    required this.price,
    required this.offerId,
  });

  Map<String, dynamic> toJson() => {
        'price': price,
      };
}
