import 'package:http/http.dart';
import 'dart:convert';
import 'dart:io';
import 'package:rebound_mtb/Error_Handling/AppException.dart';

import 'package:rebound_mtb/model/StrapiNewsDemo.dart';

class StrapiNetwork{

  Future<StrapiNewsDemo> getNews() async {
    print("getNews() called");
    var finalUrl = "http://localhost:1337/news-posts/";
    print("URL set");

    try {
      print("try block entered");
      final response = await get(Uri.encodeFull(finalUrl),
          headers: {HttpHeaders.authorizationHeader: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVlZWUyNGE5NTliNWU2NGIyMjE5YjdhYSIsImlhdCI6MTU5Mjc0MzA3NSwiZXhwIjoxNTk1MzM1MDc1fQ.hwlLxgn8j57i7h0W-eHau4OXld5doi5TBt-rPhmTkPc"})
          .timeout(
          Duration(seconds: 30));

      switch(response.statusCode){

        case 200:
          print("Got a ${response.statusCode} back!");
          return StrapiNewsDemo.fromJson(json.decode(response.body));

        case 401:
          print("Got a ${response.statusCode} back!");
          throw UnauthorisedException(response.body.toString());

        case 404:
          print("Got a ${response.statusCode} back!");
          throw NotFoundException(response.body.toString());

        case 429:
          print("Got a ${response.statusCode} back!");
          throw TooManyRequestsException(response.body.toString());

        default:
          print("Got a ${response.statusCode} back!");
          throw FetchDataException("Error occurred while communicating with server with status code: ${response.statusCode}");


      }
//
//      if(response.statusCode == 200){
//        print(weatherForecastModel.fromJson(json.decode(response.body)));
//        return weatherForecastModel.fromJson(json.decode(response.body));
//
//      }else{
//        throw Exception("Error getting weather forecast" + response.statusCode.toString());
//      }
    } on SocketException  {
      print("Got a SocketException!");
      throw FetchDataException("No internet connection");
    }

  }


}