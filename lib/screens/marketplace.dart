import 'package:flutter/material.dart';
import 'package:flutter_1/screens/item_detail_page.dart';
import 'package:provider/provider.dart';
import '../item_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Marketplace extends StatelessWidget {
  const Marketplace({super.key});

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<ItemProvider>(context).items;
    final screenWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ItemDetailPage(item: item)));
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (kIsWeb)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          item.photos[0].path,
                          width: screenWidth * 0.2,
                          height: screenWidth * 0.2,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          item.photos[0],
                          width: screenWidth * 0.4,
                          height: screenWidth * 0.4,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  const SizedBox(
                      width:
                          10), // Add some space between the image and the text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontSize: screenWidth * 0.05, // Adjust text size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                            height: 5), // Add some space between text and row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "£${item.price}",
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Expiry: ${item.expiryDate}",
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
