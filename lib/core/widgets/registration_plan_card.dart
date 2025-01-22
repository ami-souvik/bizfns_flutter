import 'package:bizfns/core/utils/colour_constants.dart';
import 'package:flutter/material.dart';
import 'package:sizing/sizing.dart';

import '../../features/auth/Signup/model/pre_registration_data.dart';


class RegistrationPlanCard extends StatelessWidget {
  int index;
  bool isSelected;
  VoidCallback _onTap;
  PlanList planList;
   RegistrationPlanCard(this.index, this.isSelected,this.planList,this._onTap);

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: _onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0.ss)
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: isSelected ? 2.ss :0.ss, color:isSelected ? AppColor.APP_BAR_COLOUR: Colors.transparent),
            borderRadius: BorderRadius.circular(10.ss),
          ),
          width: MediaQuery.of(context).size.width / 3.5,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                width: MediaQuery.of(context).size.width / 3.5,

                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0)),
                    color: Colors.lightBlueAccent.withOpacity(0.25)),
                child: Container(
                  height: MediaQuery.of(context).size.height / 24.ss,
                  child: Text(
                    planList.planName??"",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    maxLines: 2,
                    style: TextStyle(fontWeight: FontWeight.w700,fontSize: 12.fss),
                  ),
                ),
              ),

              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                children: [
                  Text("${planList.userCount} users", style: TextStyle(fontWeight: FontWeight.w400),textAlign: TextAlign.center,overflow: TextOverflow.clip,),
                  Container(height: 5.ss,),
                  Text(planList.description??"",maxLines: 4,
                    style: TextStyle(fontWeight: FontWeight.w300,fontSize: 10.fss),textAlign: TextAlign.center,overflow: TextOverflow.clip,),
                  Container(height: 5.ss,),
                  Text("\$ ${planList.price}", style: TextStyle(fontWeight: FontWeight.w400,fontSize:18.fss, color: Colors.lightBlueAccent.withOpacity(0.45)),),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
