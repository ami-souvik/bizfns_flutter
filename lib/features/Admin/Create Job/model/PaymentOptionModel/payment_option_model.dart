class PaymentOptionModel{
  final String name;
  final List<Menu> subMenu;

  PaymentOptionModel({
    required this.name,
    required this.subMenu
  });

}

class Menu{
  final String name;
  final String image;

  Menu({required this.name,required this.image});


}