import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:expandable/expandable.dart';
import 'package:sizing/sizing.dart';
import '../../../core/utils/colour_constants.dart';
import '../../../core/utils/fonts.dart';
import '../Material/provider/material_provider.dart';

class CategorySubcategoryListPage extends StatefulWidget {
  const CategorySubcategoryListPage({super.key});

  @override
  State<CategorySubcategoryListPage> createState() =>
      _CategorySubcategoryListPageState();
}

class _CategorySubcategoryListPageState
    extends State<CategorySubcategoryListPage> {
  TextEditingController subCategoryController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<MaterialProvider>().getMaterialAndSubCategoryData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          GoRouter.of(context).goNamed('admin');
          return true;
        },
        child: SafeArea(
            child: Scaffold(
          backgroundColor: Colors.grey.withOpacity(0.05),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.0, top: 20.0),
                child: Text(
                  'Add Category',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5.0.ss),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0.ss,
                    ),
                    color: Colors.white,
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.ss, vertical: 2.ss),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {});
                          },
                          controller: categoryController,
                          decoration: InputDecoration(
                            hintText: 'Category Name',
                            border: InputBorder.none,
                            hintStyle: CustomTextStyle(
                              fontSize: 15.fss,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey, // Adjust hint text color
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (categoryController.text.isNotEmpty) {
                            context
                                .read<MaterialProvider>()
                                .addMaterialCategory(
                                    categoryName: categoryController.text,
                                    context: context)
                                .then((value) {
                              categoryController.clear();
                              context
                                  .read<MaterialProvider>()
                                  .getMaterialAndSubCategoryData();
                              setState(() {});
                            });
                          }
                          // print(
                          //     "subcat added : ${category.pKCATEGORYID}");
                        },
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: categoryController.text.isNotEmpty
                              ? AppColor.APP_BAR_COLOUR
                              : Colors.grey,
                          child: Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: context.watch<MaterialProvider>().catList!.length,
                  itemBuilder: (context, index) {
                    final category =
                        context.watch<MaterialProvider>().catList![index];
                    return ExpandableNotifier(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Card(
                          elevation: 2,
                          child: ScrollOnExpand(
                            child: ExpandablePanel(
                              header: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                            backgroundColor: Colors.grey[200],
                                            radius: 20.ss,
                                            // Adjust the radius as needed
                                            child: Image.asset(
                                              'assets/images/four-squares-button.png',
                                              width: 20.ss,
                                              height: 20.ss,
                                              fit: BoxFit.cover,
                                            )),
                                        SizedBox(width: 8.ss),
                                        Text(
                                          category.cATEGORYNAME ??
                                              'Unknown Category',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                        onTap: () {
                                          print("category delete");
                                          showCupertinoDialog(
                                              context: context,
                                              builder: (_) {
                                                return CupertinoAlertDialog(
                                                  content: const Text(
                                                    'Are you sure, you want to delete the Category?',
                                                    style: TextStyle(
                                                      color: Color(0xff093d52),
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                  actions: [
                                                    CupertinoButton(
                                                      child: const Text(
                                                        'Yes, Delete',
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        //-----Delete will be here----//
                                                        context
                                                            .read<
                                                                MaterialProvider>()
                                                            .deleteCategoryAndSubcategory(
                                                                categoryId: category
                                                                    .pKCATEGORYID
                                                                    .toString(),
                                                                context:
                                                                    context,
                                                                subcategoryId:
                                                                    '')
                                                            .then((value) {
                                                          context
                                                              .read<
                                                                  MaterialProvider>()
                                                              .getMaterialAndSubCategoryData();
                                                          setState(() {});
                                                          context.pop();
                                                        });
                                                      },
                                                    ),
                                                    CupertinoButton(
                                                      child: const Text(
                                                        'No',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                      onPressed: () {
                                                        context.pop(false);
                                                        // setState(
                                                        //     () {});
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        child: Icon(Icons.delete))
                                  ],
                                ),
                              ),
                              collapsed: Container(),
                              expanded: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            BorderRadius.circular(5.0.ss),
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1.0.ss,
                                        ),
                                        color: Colors.white,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5.ss, vertical: 2.ss),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              onChanged: (value) {
                                                setState(() {});
                                              },
                                              controller: subCategoryController,
                                              decoration: InputDecoration(
                                                hintText: 'Sub Category Name',
                                                border: InputBorder.none,
                                                hintStyle: CustomTextStyle(
                                                  fontSize: 15.fss,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors
                                                      .grey, // Adjust hint text color
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              print(
                                                  "subcat added : ${category.pKCATEGORYID}");
                                              if (subCategoryController
                                                  .text.isNotEmpty) {
                                                context
                                                    .read<MaterialProvider>()
                                                    .addMaterialSubCategory(
                                                        context: context,
                                                        subCategoryName:
                                                            subCategoryController
                                                                .text,
                                                        categoryID: category
                                                            .pKCATEGORYID
                                                            .toString())
                                                    .then((value) {
                                                  subCategoryController.clear();
                                                  context
                                                      .read<MaterialProvider>()
                                                      .getMaterialAndSubCategoryData();
                                                  setState(() {});
                                                });
                                              }
                                            },
                                            child: CircleAvatar(
                                              radius: 15,
                                              backgroundColor:
                                                  subCategoryController
                                                          .text.isNotEmpty
                                                      ? AppColor.APP_BAR_COLOUR
                                                      : Colors.grey,
                                              child: Icon(Icons.add),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount:
                                        category.subCategory?.length ?? 0,
                                    itemBuilder: (context, subIndex) {
                                      final subCategory =
                                          category.subCategory?[subIndex];
                                      return Visibility(
                                        visible: subCategory!
                                            .pkSubcategoryName!.isNotEmpty,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius:
                                                    BorderRadius.circular(5.0)),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 40.0,
                                                  vertical: 10.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    subCategory
                                                            ?.pkSubcategoryName ??
                                                        'Unknown Subcategory',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        showCupertinoDialog(
                                                            context: context,
                                                            builder: (_) {
                                                              return CupertinoAlertDialog(
                                                                content:
                                                                    const Text(
                                                                  'Are you sure, you want to delete the Sub-Category?',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xff093d52),
                                                                    fontSize:
                                                                        17,
                                                                  ),
                                                                ),
                                                                actions: [
                                                                  CupertinoButton(
                                                                    child:
                                                                        const Text(
                                                                      'Yes, Delete',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .green,
                                                                      ),
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      //-----Delete will be here----//
                                                                      context
                                                                          .read<
                                                                              MaterialProvider>()
                                                                          .deleteCategoryAndSubcategory(
                                                                              categoryId: category.pKCATEGORYID.toString(),
                                                                              context: context,
                                                                              subcategoryId: subCategory.pkSubcategoryId.toString())
                                                                          .then((value) {
                                                                        context
                                                                            .read<MaterialProvider>()
                                                                            .getMaterialAndSubCategoryData();
                                                                        setState(
                                                                            () {});
                                                                        context
                                                                            .pop();
                                                                      });
                                                                    },
                                                                  ),
                                                                  CupertinoButton(
                                                                    child:
                                                                        const Text(
                                                                      'No',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      context.pop(
                                                                          false);
                                                                      // setState(
                                                                      //     () {});
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            });
                                                      },
                                                      child: Icon(Icons.delete))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              theme: ExpandableThemeData(
                                iconColor: Colors.blue,
                                headerAlignment:
                                    ExpandablePanelHeaderAlignment.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        )));
  }
}
