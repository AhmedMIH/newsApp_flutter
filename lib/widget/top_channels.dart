import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/bloc/get_sources_bloc.dart';
import 'package:newsapp/element/error_element.dart';
import 'package:newsapp/element/loader_element.dart';
import 'package:newsapp/model/source.dart';
import 'package:newsapp/model/source_response.dart';
import 'package:newsapp/screens/source_detail.dart';

class TopChannelsWidget extends StatefulWidget {
  @override
  _TopChannelsWidgetState createState() => _TopChannelsWidgetState();
}

class _TopChannelsWidgetState extends State<TopChannelsWidget> {
  @override
  void initState() {
    super.initState();
    getSourcesBloc.getSource();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SourceResponse>(
      stream: getSourcesBloc.subject.stream,
      builder: (context, AsyncSnapshot<SourceResponse> snapshot) {
        print("true");
        if (snapshot.hasData) {
          print("true2");
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            print("true3");
            return buildErrorWidget(snapshot.data.error);
          }
          return _buildTopChannelWidget(snapshot.data);
        } else if (snapshot.hasError) {
          print("true4");
          return buildErrorWidget(snapshot.error);
        } else {
          print("true5");
          return buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildTopChannelWidget(SourceResponse data) {
    List<Sources> sources = data.sources;
    if (sources.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("No Sources"),
          ],
        ),
      );
    } else {
      return Container(
        height: 115.0,
        child: ListView.builder(
            itemCount: sources.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, int index) {
              return Container(
                padding: EdgeInsets.only(
                  top: 10.0,
                ),
                width: 80.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder:(context) => SourceDetail(source: sources[index])));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Hero(
                        tag: sources[index].id,
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 5.0,
                                  spreadRadius: 1.0,
                                  offset: Offset(1.0, 1.0))
                            ],
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    "assets/logos/${sources[index].id}.png")),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        sources[index].name,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            height: 1.4,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0),
                      ),
                      SizedBox(
                        height: 3.0,
                      ),
                      Text(
                        sources[index].category,
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 9.0,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
      );
    }
  }
}
