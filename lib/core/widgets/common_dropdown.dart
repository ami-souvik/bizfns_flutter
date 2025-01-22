import 'package:bizfns/core/widgets/common_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizing/sizing.dart';
import '../model/dropdown_model.dart';
import '../utils/alert_dialog.dart';
import '../utils/colour_constants.dart';
import '../utils/const.dart';
import '../utils/fonts.dart';

class CommonDropdown extends StatefulWidget {
  late double? height;
  late double? width;
  late bool? isInfoVisible;
  late List<DropdownModel> options;
  late DropdownModel selectedValue;
  final Color? borderColor;
  final double? borderRadius;
  final FocusNode? focusNode;
  final Function(DropdownModel) onChange;

  CommonDropdown({
    this.isInfoVisible,
    this.width,
    this.height = 50,
    required this.selectedValue,
    required this.options,
    required this.onChange,
    this.borderColor,
    this.borderRadius,
    this.focusNode,
    Key? key,
  }) : super(key: key);

  @override
  State<CommonDropdown> createState() => _CommonCommonDropdownState();
}

class _CommonCommonDropdownState extends State<CommonDropdown> {
  String? textValue;



  @override
  Widget build(BuildContext context) {
    // print(widget.options.length);
    // print("Selected ==>>>" + widget.selectedValue.label.toString());
    // for (int i = 0; i < widget.options.length; i++) {
    //   print(widget.options[i].label);
    // }
    return Container(
        height: widget.height,
        width: widget.width ?? MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 10.ss),
        decoration: BoxDecoration(
          color: widget.borderColor??Colors.blueGrey.withOpacity(0.03),
            border: Border.all(color:widget.borderColor??Colors.black87),
            borderRadius: BorderRadius.all(Radius.circular(5.ss))),
        //color: Colors.lightGreen,
        child: DropdownButton2(
          focusNode: widget.focusNode,
            underline: Container(
              padding: EdgeInsets.symmetric(vertical: 20.ss),
              height: 0.ss,color: Colors.white,),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15.ss),
                  bottomLeft: Radius.circular(15.ss),

                ),
              ),
            ),
            iconStyleData: IconStyleData(
              icon:  Padding(
                padding:  EdgeInsets.all(8.0.ss),
                child: Icon(Icons.arrow_drop_down,size: 20.ss,color:  Colors.black26),
              ),
            ),
            isExpanded: true,
            barrierColor: Colors.transparent,
            hint: CommonText(
              text: 'Select Item',
              maxLine: 5,
              textStyle: CustomTextStyle(
                fontSize: 14.fss,
                fontWeight: FontWeight.w200,
                color: Theme.of(context).hintColor,
              ),
            ),
            items: [
              for (var data in widget.options)
                DropdownMenuItem(
                  alignment: Alignment.center,
                  child:  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0.ss),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            children: [
                              CommonText(
                                textOverflow :TextOverflow.visible,
                                text:data.name??"",

                                textStyle: TextStyle(fontSize: data.name!.length>60 ? 12.fss: 14.fss,fontWeight: FontWeight.w400 ,color: data.id =="-1"? Colors.grey: Colors.black87),

                              ),
                              Container(height: 5.ss,),
                              data != widget.options.last?
                              Divider( height: 1.ss, color: Colors.grey.shade600)
                              :SizedBox(),
                              Container(height: 5.ss,)

                            ],
                          ),
                        ),
                        data.id! == "-1" ?
                        Padding(
                          padding:  EdgeInsets.symmetric(vertical: 5.0.ss,horizontal: 5.0.ss),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                  onTap: (){
                                   context.pop();
                                  },
                                  child: Icon( Icons.clear, size: 16,color: Colors.grey,)),
                            ],
                          ),
                        )
                            :
                        widget.isInfoVisible != null && widget.isInfoVisible == true?
                        Padding(
                          padding:  EdgeInsets.symmetric(vertical: 5.0.ss,horizontal: 5.0.ss),
                          child: InkWell(
                              onTap: (){
                                ShowDialog(
                                  headerColor: Colors.grey,
                                    context: context,title: "Info",msg: data.desc??"",
                                );
                              },
                              child: ImageIcon( AssetImage('assets/images/information_button.png'), size: 16,color: AppColor.APP_BAR_COLOUR,)),
                        )
                            :SizedBox()
                      ],
                    ),
                  ),
                  value: data.id,
                )
            ],
            selectedItemBuilder: (BuildContext context) {
              return widget.options.map<Widget>((DropdownModel item) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonText(
                      maxLine: 2,
                     textOverflow: TextOverflow.ellipsis,
                     text: item.name??"",
                      textStyle: CustomTextStyle(
                        fontSize: 14.fss,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87
                      ),
                    ),
                  ],
                );
              }).toList();
            },
            value: widget.selectedValue.id,
            onChanged:(value){
              for(var item in widget.options){
                if(item.id==value){
                  widget.onChange(item);
                  break;
                }
              }

            }
          // buttonHeight: 40,
          //  buttonWidth: 140,
          //  itemHeight: 40,
        )


    );
  }
}
