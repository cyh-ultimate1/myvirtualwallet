import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:myvirtualwallet/Services/OnlineServices.dart';
import 'package:myvirtualwallet/main.dart';

void main() {
  group('tests for login component', () {

    setUp(() {

    });

    test('login test:', () async {

      var expectedResult = "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoidXNlcjEiLCJqdGkiOiJlNWEyMzExYS04MmZiLTRjOTctYjExZC05MjNmNjg5ZDNkY2EiLCJleHAiOjE2MjkwNTIyNzEsImlzcyI6Iklzc3Vlci5jb20iLCJhdWQiOiJBdWRpZW5jZS5jb20ifQ.NYlxrjEhRQwhQMQtduFB8wpwPeElEk0aFk697_wFbqKlI3FryB-Dnp6RdipJ1j0nIUvVpfy2e0O1rAE3eiPCgw";

      // act
      var actualResult = await loginUser("user1", "Abc123!");

      // assert
      expectLater(actualResult.body, expectedResult);
    });


  });
}
