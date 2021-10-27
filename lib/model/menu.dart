
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raktkhoj/model/Food.dart';
import 'package:raktkhoj/model/request.dart';

class Menu {
  static List<Food> menu = [
    Food(
        id: "1",
        image: "images/logo.png",
        name: "LASAGNE",
        price: "\$12"),
    Food(
        id: "3",
        image: "images/logo.png",
        name: "MUSHROOM RISOTTO",
        price: "\$4"),
    Food(
        id: "4",
        image: "images/logo.png",
        name: "CIOPPINO",
        price: "\$30"),
    Food(
        id: "5",
        image:"images/logo.png",
        name: "SEAFOOD PLATTER",
        price: "\$22"),
    Food(
        id: "2",
        image:"images/logo.png",
        name: "TORTELLINI WITH BROCCOLI",
        price: "\$8"),
    Food(
        id: "6",
        image: "images/logo.png",
        name: "MEAT ROLL",
        price: "\$19"),
    Food(
        id: "7",
        image:"images/logo.png",
        name: "SALMON SALAD",
        price: "\$25"),
    Food(
        id: "8",
        image:"images/logo.png",
        name: "MEATBALLS AND PASTA",
        price: "\$7"),
    Food(
        id: "9",
        image: "images/logo.png",
        name: "STEAK AU POIVRE",
        price: "\$63"),
    Food(
        id: "10",
        image: "images/logo.png",
        name: "CHICKEN SALAD",
        price: "\$43"),
  ];


  static Food getFoodById(id) {
    return menu.where((p) => p.id == id).first;
  }
}