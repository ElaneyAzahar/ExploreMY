import 'package:flutter/material.dart';

class ItemCounter extends StatefulWidget {
  final double adultPrice;
  final double childPrice;
  final int initialAdultQty;
  final int initialKidsQty;
  final void Function(int adultQty, int kidsQty, double total) onChanged;

  const ItemCounter({
    super.key,
    required this.adultPrice,
    required this.childPrice,
    required this.onChanged,
    this.initialAdultQty = 0,
    this.initialKidsQty = 0,
  });

  @override
  State<ItemCounter> createState() => _ItemCounterState();
}

class _ItemCounterState extends State<ItemCounter> {
  int adultTicket = 0;
  int kidsTicket = 0;

  bool get isSingleItem => widget.childPrice <= 0;

  double get totalPrice =>
      (adultTicket * widget.adultPrice) + (kidsTicket * widget.childPrice);

  void _notifyParent() {
    widget.onChanged(adultTicket, kidsTicket, totalPrice);
  }

  @override
  void initState() {
    super.initState();
    adultTicket = widget.initialAdultQty;
    kidsTicket = widget.initialKidsQty;
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifyParent());
  }

  @override
  void didUpdateWidget(covariant ItemCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialAdultQty != widget.initialAdultQty ||
        oldWidget.initialKidsQty != widget.initialKidsQty) {
      setState(() {
        adultTicket = widget.initialAdultQty;
        kidsTicket = widget.initialKidsQty;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _notifyParent());
    }
  }

  void _incAdult() { setState(() => adultTicket++); _notifyParent(); }
  void _decAdult() { setState(() => adultTicket = adultTicket > 0 ? adultTicket - 1 : 0); _notifyParent(); }
  void _incKids() { setState(() => kidsTicket++); _notifyParent(); }
  void _decKids() { setState(() => kidsTicket = kidsTicket > 0 ? kidsTicket - 1 : 0); _notifyParent(); }

  @override
  Widget build(BuildContext context) {
    // ✅ Logic to display "FREE" if total is 0
    final bool isFree = totalPrice == 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TicketCounterRow(
          label: isSingleItem ? 'Quantity' : 'Adult Ticket',
          value: adultTicket,
          onAdd: _incAdult,
          onRemove: _decAdult,
        ),
        if (!isSingleItem) ...[
          const SizedBox(height: 16),
          TicketCounterRow(
            label: 'Kids Ticket',
            value: kidsTicket,
            onAdd: _incKids,
            onRemove: _decKids,
          ),
        ],
        const SizedBox(height: 20),

        // ✅ Updated Total Display
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          decoration: BoxDecoration(
            // Change background color slightly if free to highlight it
            color: isFree ? Colors.green.shade50 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isFree ? Colors.green.withOpacity(0.5) : Colors.red.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Total Price: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                isFree ? 'FREE' : 'RM ${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  // Green text for FREE, Black for price
                  color: isFree ? Colors.green.shade700 : Colors.black87, 
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TicketCounterRow extends StatelessWidget {
  final String label;
  final int value;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const TicketCounterRow({
    super.key,
    required this.label,
    required this.value,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5, spreadRadius: 1)],
          ),
          child: Row(
            children: [
              _buildIconButton(Icons.remove, onRemove),
              SizedBox(
                width: 40,
                child: Text(value.toString(), textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              _buildIconButton(Icons.add, onAdd),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onPressed,
        child: Padding(padding: const EdgeInsets.all(8.0), child: Icon(icon, color: Colors.red.shade700)),
      ),
    );
  }
}