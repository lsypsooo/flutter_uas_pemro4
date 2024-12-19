String baseUrl = "http://192.168.100.149:3000";

//auth
String register = "$baseUrl/users/register";
String login = "$baseUrl/users/login";

//image
String imageUrl = '$baseUrl/img/game/';

//Tags
String getAllTags = "$baseUrl/tags/get-all";
String insertTags = "$baseUrl/tags/insert";
String hapusTags = "$baseUrl/tags/delete/";
String editTags = "$baseUrl/tags/edit/";

//game
String getAllGame = "$baseUrl/game/get-all/";
String hapusGame = "$baseUrl/game/delete/";
String inputGame = "$baseUrl/game/insert";
String editGame = "$baseUrl/game/edit/";

//transaction
String insertTransaksi = "$baseUrl/transaction/insert";
String getTransaksi = "$baseUrl/transaction/get-all";
String getTransaksiByUser = "$baseUrl/transaction/get/";
String confirmTranskasi = "$baseUrl/transaction/confirm-transaction/";