import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bloc/presentation/bloc/cubit/location_cubit.dart';

import '../../../constants.dart';
import '../../../widgets/custom_buttom.dart';
import '../../bloc/bloc/weather_bloc.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  final locController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgrd,
      body: BlocBuilder<LocationCubit,String>(
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: Text("Settings", style: headingStyle,)),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Text("Location",
                                style: subtitleStyle)),
                        Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: locController,
                              style: subtitleStyle,
                              validator: (value) {
                                if(value!.isEmpty){
                                  return "*required";
                                }else{
                                  return null;
                                }
                                
                              },
                              decoration: const InputDecoration(
                                  enabledBorder:
                                      UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: white))),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text("Current location: $state",
                      style: subtitleStyle
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      color: primary,
                      title:'Submit',
                      onPressed: () {
                        if(_formkey.currentState!.validate()){
                          context.read<LocationCubit>().saveLocation(locController.text.trim());
                          BlocProvider.of<WeatherBloc>(context).add(UpdateLocation(locController.text.trim()));
                          Navigator.pop(context);
                        }
                      }
                    ),
                          
                    
                          
                  ],
                ),
              ),
            ) 
          );
        },
      ),
    );
  }
}