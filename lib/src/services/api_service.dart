class ApiService {
  ApiService._(); //prevents instantiation

  static const getAllProuctsAPI = 'https://dummyjson.com/products';

  static getAllProductsWithPagination(int skip) =>
      'https://dummyjson.com/products?limit=10&skip=$skip';

  static getAllQuotes(int skip) =>
      'https://dummyjson.com/quotes?limit=50&skip=$skip';

  static final getRandomQuotes = 'https://dummyjson.com/quotes/random';
}
