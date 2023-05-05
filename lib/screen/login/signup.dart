import 'package:musicapp/screen/login/signin.dart';

import '../../services/firebase/flutterfire.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

extension StringExtensions on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

class SignupWidget extends StatefulWidget {
  const SignupWidget({Key? key}) : super(key: key);
  static String name = '';
  static String email = '';
  static DateTime date = DateTime.now();
  static String password = '';
  @override
  _SignupWidgetState createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  TextEditingController? name;
  TextEditingController? email;
  TextEditingController? password;
  late bool passwordVisibility;
  DateTime? datePicked;
  bool? checkboxValue;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    passwordVisibility = false;
    name ??= TextEditingController();
    email ??= TextEditingController();
    password ??= TextEditingController();
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    name?.dispose();
    email?.dispose();
    password?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFF25282C),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: const AlignmentDirectional(-0.9, 0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Text(
                      'Sign Up',
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                            fontFamily: 'Poppins',
                            color: FlutterFlowTheme.of(context).primaryBtnText,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(-0.8, 0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                    child: Text(
                      'Create account to contiune!',
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                            fontFamily: 'Poppins',
                            color: FlutterFlowTheme.of(context).primaryBtnText,
                          ),
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(-0.85, 0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Text(
                      'Name',
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                            fontFamily: 'Poppins',
                            color: FlutterFlowTheme.of(context).primaryBtnText,
                          ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      controller: name,
                      autofocus: true,
                      //autofillHints: [AutofillHints.email],
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: 'Enter your Name',
                        hintStyle: FlutterFlowTheme.of(context).bodyText2,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF4E5D75),
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF0685CE),
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFFF0000),
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFFF0000),
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (name) {
                        if (!name!.isNotEmpty) {
                          return 'please enter valid name';
                        }
                      },
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                            fontFamily: 'Poppins',
                            color: FlutterFlowTheme.of(context).primaryBtnText,
                          ),
                      keyboardType: TextInputType.name,
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(-0.85, 0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Text(
                      'Email Address',
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                            fontFamily: 'Poppins',
                            color: FlutterFlowTheme.of(context).primaryBtnText,
                          ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      controller: email,
                      autofocus: true,
                      autofillHints: [AutofillHints.email],
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        hintStyle: FlutterFlowTheme.of(context).bodyText2,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF4E5D75),
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF0685CE),
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFFF0000),
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFFF0000),
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                            fontFamily: 'Poppins',
                            color: FlutterFlowTheme.of(context).primaryBtnText,
                          ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (email) {
                        if (email!.isValidEmail()) {
                          SignupWidget.email = email;
                        } else {
                          return 'please enter valid name';
                        }
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(-0.85, 0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Text(
                      'Password',
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                            fontFamily: 'Poppins',
                            color: FlutterFlowTheme.of(context).primaryBtnText,
                          ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      controller: password,
                      validator: (password) {
                        if (password == null) {
                          return 'please enter valid password';
                        }
                      },
                      autofocus: true,
                      obscureText: !passwordVisibility,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        hintStyle: FlutterFlowTheme.of(context).bodyText2,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF4E5D75),
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF0685CE),
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFFF0000),
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFFF0000),
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: InkWell(
                          onTap: () => setState(
                            () => passwordVisibility = !passwordVisibility,
                          ),
                          focusNode: FocusNode(skipTraversal: true),
                          child: Icon(
                            passwordVisibility
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: const Color(0xFF757575),
                            size: 22,
                          ),
                        ),
                      ),
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                            fontFamily: 'Poppins',
                            color: FlutterFlowTheme.of(context).primaryBtnText,
                          ),
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(-0.85, 0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 10),
                    child: Text(
                      'Birthday',
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                            fontFamily: 'Poppins',
                            color: FlutterFlowTheme.of(context).primaryBtnText,
                          ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 2, 0, 0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            final datePickedDate = await showDatePicker(
                              context: context,
                              initialDate: getCurrentTimestamp,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2050),
                            );

                            if (datePickedDate != null) {
                              setState(() {
                                datePicked = DateTime(
                                  datePickedDate.year,
                                  datePickedDate.month,
                                  datePickedDate.day,
                                );
                              });
                            }
                          },
                          text: '',
                          icon: Icon(
                            Icons.calendar_today,
                            color: FlutterFlowTheme.of(context).primaryBtnText,
                            size: 25,
                          ),
                          options: FFButtonOptions(
                            width: 55,
                            height: 50,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                5, 0, 0, 0),
                            color: const Color(0xFF0685CE),
                            textStyle:
                                FlutterFlowTheme.of(context).subtitle2.override(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                    ),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                        child: Text(
                          valueOrDefault<String>(
                            dateTimeFormat('yyyy-MM-dd', datePicked),
                            'Your Birthday',
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyText1
                              .override(
                                fontFamily: 'Poppins',
                                color:
                                    FlutterFlowTheme.of(context).primaryBtnText,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(-0.85, 0),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                          child: Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                              ),
                              unselectedWidgetColor: const Color(0xFFF5F5F5),
                            ),
                            child: Checkbox(
                              value: checkboxValue ??= false,
                              onChanged: (newValue) async {
                                setState(() => checkboxValue = newValue!);
                              },
                              activeColor:
                                  FlutterFlowTheme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Text(
                          'I agree to terms and conditions',
                          style: FlutterFlowTheme.of(context)
                              .bodyText1
                              .override(
                                fontFamily: 'Poppins',
                                color:
                                    FlutterFlowTheme.of(context).primaryBtnText,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: FFButtonWidget(
                    onPressed: () {
                      SignupWidget.name = name!.text;
                      SignupWidget.password = password!.text;
                      SignupWidget.email = email!.text;
                      SignupWidget.date = datePicked!;
                      register(SignupWidget.email, SignupWidget.password)
                          .then((value) {
                        if (value == "success") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>  SigninWidget()));
                        } else {
                          showDialog(
                              context: context,
                              builder: ((context) => AlertDialog(
                                    content: Text(value!),
                                  )));
                        }
                      });
                    },
                    text: 'Sign Up',
                    options: FFButtonOptions(
                      width: 300,
                      height: 50,
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      iconPadding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: const Color(0xFF0685CE),
                      textStyle:
                          FlutterFlowTheme.of(context).subtitle2.override(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                              ),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Text(
                          'Do you have an account? ',
                          style: FlutterFlowTheme.of(context)
                              .bodyText1
                              .override(
                                fontFamily: 'Poppins',
                                color:
                                    FlutterFlowTheme.of(context).primaryBtnText,
                              ),
                        ),
                      ),
                      Text(
                        'Sign In',
                        style: FlutterFlowTheme.of(context).bodyText1.override(
                              fontFamily: 'Poppins',
                              color: const Color(0xFF0685CE),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
