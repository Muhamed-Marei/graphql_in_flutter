import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });
  @override
  //git clone -b widget_design https://github.com/JasperEssien2/music_mates_app
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink("https://countries.trevorblades.com/");
    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(),
      ),
    );
    return GraphQLProvider(
      client: client,
      child: const MaterialApp(home: MyHomePage()),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    const String query = r"""
                    query GetContinent($code : ID!){
                      continent(code:$code){
                        name
                        countries{
                          name
                          code
                        }
                      }
                    }
                  """;
    return Query(
        options: QueryOptions(
            document: gql(query),
            variables: const <String, dynamic>{"code": "AF"}),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (result.data == null) {
            return const Center(
              child: Text("Data Not Found!!!"),
            );
          } else {
            return Scaffold(
              body: ListView.builder(
                  itemCount: result.data!['continent']['countries'].length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        result.data!['continent']['countries'][index]["name"],
                      ),
                      subtitle: Text(result.data!['continent']['countries']
                          [index]["code"]),
                    );
                  }),
            );
          }
        });
  }
}
