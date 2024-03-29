import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crud/providers/login_form_provider.dart';
import 'package:crud/widgets/widgets.dart';
import 'package:crud/ui/input_decorations.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
              child: Column(
                children: [

                  SizedBox( height: 250 ),

                  CardContainer(
                    child: Column(
                      children: [

                        SizedBox( height: 10 ),
                        Text('Login',
                          style: Theme.of(context).textTheme.headline5,
                          
                        ),
                        SizedBox( height: 30 ),

                        ChangeNotifierProvider(
                          create: (_) => LoginFormProvider(),
                          child: _LoginForm()
                        ),


                      ],
                    )
                  ),

                  SizedBox( height: 50 ),

                  Text('Crear una nueva cuenta',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    )
                  )

              ]
            )
          )
        )
      );
  }
}



class _LoginForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final loginFormProvider = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        key: loginFormProvider.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [


            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'example@gmail.com',
                labelText: 'Correo electónico',
                prefixIcon: Icons.alternate_email_rounded
              ),
              onChanged: ( value ) => loginFormProvider.email = value,
              validator: (value) {
                
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp  = new RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                  ? null
                  : 'Correo electrónico invalido.';
              },
            ),

            SizedBox(
              height: 30,
            ),

            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: '********',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline
              ),
              onChanged: ( value ) => loginFormProvider.password = value,
              validator: ( value ) {
                return ( value != null && value.length >= 8 )
                  ? null
                  : 'La contraseña debe de ser 8 caracteres.';
              }
            ),

            SizedBox(
              height: 30,
            ),

            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 15
                ),
                child: Text(
                  loginFormProvider.isLoading ? 'Espere...' :'Ingresar',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              ),
              onPressed: loginFormProvider.isLoading ? null : () async{
                FocusScope.of(context).unfocus();
                if( !loginFormProvider.isValidForm() ) return; 

                loginFormProvider.isLoading = true;

                /* Fingir peticion a backend */
                await Future.delayed(
                  Duration(seconds: 2)
                );

                /* TODO: Validar si el login es correcto */
                loginFormProvider.isLoading = false;

                Navigator.pushReplacementNamed(context, 'home');
              },
            )

          ],
        ),
      )
    );
  }
}