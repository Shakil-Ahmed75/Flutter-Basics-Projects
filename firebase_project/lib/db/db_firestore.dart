
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_04_05/models/product_model.dart';

const String COLLECTION_PRODUCT = 'Products04';

class DBFireStore {
  static final Firestore db = Firestore.instance;

  static Future<void> addProduct(Product product) async {
    product.id = DateTime.now().millisecondsSinceEpoch;
    final doc = db.collection(COLLECTION_PRODUCT).document(product.id.toString());
    return doc.setData(product.toMap());
  }

  static Future<List<Product>> getProducts() async {
    List<Product> products = [];
    final querySnapShot = await db.collection(COLLECTION_PRODUCT).getDocuments();
    if(querySnapShot != null) {
      products = querySnapShot.documents.map((document) => Product.fromMap(document.data)).toList();
    }
    return products;
  }

  static Future<Product> getProductById(int id) async {
    final snapshot = await db.collection(COLLECTION_PRODUCT).document(id.toString()).get();
    return Product.fromMap(snapshot.data);
  }

  static Future<List<Product>> getProductsByCategory(String category) async {
    List<Product> products = [];
    final querySnapShot = await db.collection(COLLECTION_PRODUCT).where(COL_PRODUCT_CATEGORY, isEqualTo: category).getDocuments();
    if(querySnapShot != null) {
      products = querySnapShot.documents.map((document) => Product.fromMap(document.data)).toList();
    }
    return products;
  }

  static Future<void> updateFavorite(int id, int value) async {
    final doc = db.collection(COLLECTION_PRODUCT).document(id.toString());
    return doc.updateData({COL_PRODUCT_FAVORITE : value});
  }

  static Future<void> deleteProduct(int id) async {
    return db.collection(COLLECTION_PRODUCT).document(id.toString()).delete();
  }
  
}