"""
Economy log generators.

Contains 15 log types for economic events including:
- Gold transactions
- Trading between players
- Auction house activity
- Vendor interactions
- Mail with gold/items
"""

import random
from typing import Any, Dict

from mmofakelog.core.constants import (
    AUCTION_FEE_PERCENT,
    MAX_AUCTION_PRICE,
    MAX_GOLD,
    MAX_VENDOR_PRICE,
    MIN_AUCTION_PRICE,
    MIN_VENDOR_PRICE,
)
from mmofakelog.core.registry import register_log_type
from mmofakelog.core.types import LogCategory, LogSeverity, RecurrencePattern
from mmofakelog.data.items import generate_item
from mmofakelog.data.names import generate_character_name
from mmofakelog.data.zones import generate_zone
from mmofakelog.generators.base import BaseLogGenerator


# =============================================================================
# GOLD TRANSACTIONS
# =============================================================================


@register_log_type(
    name="economy.gold_gain",
    category=LogCategory.ECONOMY,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.FREQUENT,
    description="Gold earned",
    text_template="[{timestamp}] GOLD_GAIN: {char_name} +{amount}g (source: {source})",
)
class EconomyGoldGainGenerator(BaseLogGenerator):
    """Generates gold gain log entries."""

    SOURCES = [
        "quest_reward", "mob_loot", "vendor_sale", "auction_sale",
        "trade", "mail", "dungeon_bonus", "daily_reward",
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        source = random.choice(self.SOURCES)
        # Amount varies by source
        amounts = {
            "quest_reward": (10, 500),
            "mob_loot": (1, 50),
            "vendor_sale": (1, 1000),
            "auction_sale": (10, 10000),
            "trade": (1, 50000),
            "mail": (1, 10000),
            "dungeon_bonus": (50, 500),
            "daily_reward": (10, 100),
        }
        min_amt, max_amt = amounts.get(source, (1, 100))

        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "amount": random.randint(min_amt, max_amt),
            "source": source,
            "zone": generate_zone() if source in ("quest_reward", "mob_loot") else None,
        }


@register_log_type(
    name="economy.gold_spend",
    category=LogCategory.ECONOMY,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.FREQUENT,
    description="Gold spent",
    text_template="[{timestamp}] GOLD_SPEND: {char_name} -{amount}g (target: {target})",
)
class EconomyGoldSpendGenerator(BaseLogGenerator):
    """Generates gold spend log entries."""

    TARGETS = [
        "vendor_purchase", "auction_bid", "auction_buyout", "repair",
        "training", "travel", "respec", "guild_bank",
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        target = random.choice(self.TARGETS)
        amounts = {
            "vendor_purchase": (1, 500),
            "auction_bid": (10, 5000),
            "auction_buyout": (50, 20000),
            "repair": (5, 200),
            "training": (10, 1000),
            "travel": (1, 50),
            "respec": (50, 500),
            "guild_bank": (100, 10000),
        }
        min_amt, max_amt = amounts.get(target, (1, 100))

        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "amount": random.randint(min_amt, max_amt),
            "target": target,
        }


# =============================================================================
# PLAYER TRADING
# =============================================================================


@register_log_type(
    name="economy.trade_request",
    category=LogCategory.ECONOMY,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Trade initiated",
    text_template="[{timestamp}] TRADE_REQ: {from_char} requested trade with {to_char}",
)
class EconomyTradeRequestGenerator(BaseLogGenerator):
    """Generates trade request log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "from_char": kwargs.get("from_char") or generate_character_name(),
            "to_char": kwargs.get("to_char") or generate_character_name(),
            "zone": generate_zone(),
        }


@register_log_type(
    name="economy.trade_complete",
    category=LogCategory.ECONOMY,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Trade completed",
    text_template="[{timestamp}] TRADE: {char1} <-> {char2}: {gold_exchanged}g, {items_exchanged} items",
)
class EconomyTradeCompleteGenerator(BaseLogGenerator):
    """Generates trade completion log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        char1 = kwargs.get("char1") or generate_character_name()
        char2 = kwargs.get("char2") or generate_character_name()

        # Generate items exchanged
        items_char1 = [generate_item().name for _ in range(random.randint(0, 5))]
        items_char2 = [generate_item().name for _ in range(random.randint(0, 5))]

        return {
            "char1": char1,
            "char2": char2,
            "gold_exchanged": random.randint(0, 10000),
            "items_exchanged": len(items_char1) + len(items_char2),
            "char1_items": items_char1,
            "char2_items": items_char2,
            "char1_gold": random.randint(0, 5000),
            "char2_gold": random.randint(0, 5000),
        }


@register_log_type(
    name="economy.trade_cancel",
    category=LogCategory.ECONOMY,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Trade cancelled",
    text_template="[{timestamp}] TRADE_CANCEL: {char_name} cancelled trade (reason: {reason})",
)
class EconomyTradeCancelGenerator(BaseLogGenerator):
    """Generates trade cancellation log entries."""

    REASONS = [
        "player_declined", "timeout", "distance", "combat",
        "inventory_full", "modified_offer",
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "other_char": generate_character_name(),
            "reason": random.choice(self.REASONS),
        }


# =============================================================================
# AUCTION HOUSE
# =============================================================================


@register_log_type(
    name="economy.auction_list",
    category=LogCategory.ECONOMY,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Item listed on auction",
    text_template="[{timestamp}] AUCTION_LIST: {char_name} listed [{rarity}] {item_name} x{quantity} at {price}g",
)
class EconomyAuctionListGenerator(BaseLogGenerator):
    """Generates auction listing log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        item = generate_item()
        price = int(item.value * random.uniform(0.5, 3.0))
        price = max(MIN_AUCTION_PRICE, min(price, MAX_AUCTION_PRICE))

        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "item_id": item.item_id,
            "item_name": item.name,
            "rarity": item.rarity,
            "quantity": random.randint(1, item.max_stack) if item.stackable else 1,
            "price": price,
            "buyout": int(price * 1.5) if random.random() > 0.3 else None,
            "duration": random.choice([12, 24, 48]),  # hours
            "deposit": int(price * 0.05),
        }


@register_log_type(
    name="economy.auction_buy",
    category=LogCategory.ECONOMY,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Auction item purchased",
    text_template="[{timestamp}] AUCTION_BUY: {char_name} bought [{rarity}] {item_name} for {price}g",
)
class EconomyAuctionBuyGenerator(BaseLogGenerator):
    """Generates auction purchase log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        item = generate_item()
        price = int(item.value * random.uniform(0.5, 3.0))

        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "seller": generate_character_name(),
            "item_id": item.item_id,
            "item_name": item.name,
            "rarity": item.rarity,
            "price": price,
            "was_buyout": random.random() > 0.3,
        }


@register_log_type(
    name="economy.auction_bid",
    category=LogCategory.ECONOMY,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Bid placed on auction",
    text_template="[{timestamp}] AUCTION_BID: {char_name} bid {amount}g on [{rarity}] {item_name}",
)
class EconomyAuctionBidGenerator(BaseLogGenerator):
    """Generates auction bid log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        item = generate_item()
        current_bid = int(item.value * random.uniform(0.3, 1.0))
        new_bid = int(current_bid * random.uniform(1.05, 1.5))

        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "item_id": item.item_id,
            "item_name": item.name,
            "rarity": item.rarity,
            "amount": new_bid,
            "previous_bid": current_bid,
            "previous_bidder": generate_character_name() if random.random() > 0.3 else None,
        }


@register_log_type(
    name="economy.auction_expire",
    category=LogCategory.ECONOMY,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.INFREQUENT,
    description="Auction expired",
    text_template="[{timestamp}] AUCTION_EXPIRE: {char_name}'s [{rarity}] {item_name} expired (no bids)",
)
class EconomyAuctionExpireGenerator(BaseLogGenerator):
    """Generates auction expiration log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        item = generate_item()
        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "item_id": item.item_id,
            "item_name": item.name,
            "rarity": item.rarity,
            "asking_price": int(item.value * random.uniform(1.5, 5.0)),
            "deposit_lost": int(item.value * 0.05),
        }


# =============================================================================
# VENDOR INTERACTIONS
# =============================================================================


@register_log_type(
    name="economy.vendor_buy",
    category=LogCategory.ECONOMY,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.FREQUENT,
    description="Item purchased from vendor",
    text_template="[{timestamp}] VENDOR_BUY: {char_name} bought {item_name} x{quantity} for {price}g",
)
class EconomyVendorBuyGenerator(BaseLogGenerator):
    """Generates vendor purchase log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        from mmofakelog.data.items import CONSUMABLE_TYPES
        item = generate_item(item_type=random.choice(CONSUMABLE_TYPES))
        quantity = random.randint(1, 20)
        price = int(item.value * quantity)

        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "item_id": item.item_id,
            "item_name": item.name,
            "quantity": quantity,
            "price": price,
            "vendor_name": f"Vendor {generate_character_name()}",
            "zone": generate_zone(),
        }


@register_log_type(
    name="economy.vendor_sell",
    category=LogCategory.ECONOMY,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.FREQUENT,
    description="Item sold to vendor",
    text_template="[{timestamp}] VENDOR_SELL: {char_name} sold {item_name} x{quantity} for {price}g",
)
class EconomyVendorSellGenerator(BaseLogGenerator):
    """Generates vendor sale log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        item = generate_item()
        quantity = random.randint(1, 10)
        # Vendors buy at 25% of value
        price = int(item.value * 0.25 * quantity)

        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "item_id": item.item_id,
            "item_name": item.name,
            "quantity": quantity,
            "price": max(1, price),
            "zone": generate_zone(),
        }


# =============================================================================
# MAIL
# =============================================================================


@register_log_type(
    name="economy.mail_send",
    category=LogCategory.ECONOMY,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Mail with gold/items sent",
    text_template="[{timestamp}] MAIL_GOLD: {from_char} sent {gold}g and {item_count} items to {to_char}",
)
class EconomyMailSendGenerator(BaseLogGenerator):
    """Generates mail send log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        gold = random.randint(0, 10000) if random.random() > 0.3 else 0
        items = [generate_item().name for _ in range(random.randint(0, 5))]

        return {
            "from_char": kwargs.get("from_char") or generate_character_name(),
            "to_char": kwargs.get("to_char") or generate_character_name(),
            "gold": gold,
            "item_count": len(items),
            "items": items,
            "cod_amount": random.randint(0, 5000) if random.random() < 0.1 else 0,
        }


# =============================================================================
# CRAFTING AND REPAIR
# =============================================================================


@register_log_type(
    name="economy.crafting_cost",
    category=LogCategory.ECONOMY,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Crafting expense",
    text_template="[{timestamp}] CRAFT_COST: {char_name} spent {cost}g crafting [{rarity}] {item_name}",
)
class EconomyCraftingCostGenerator(BaseLogGenerator):
    """Generates crafting cost log entries."""

    PROFESSIONS = [
        "Blacksmithing", "Leatherworking", "Tailoring", "Engineering",
        "Alchemy", "Enchanting", "Jewelcrafting", "Inscription",
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        item = generate_item()
        cost = int(item.value * random.uniform(0.1, 0.5))

        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "item_id": item.item_id,
            "item_name": item.name,
            "rarity": item.rarity,
            "cost": cost,
            "profession": random.choice(self.PROFESSIONS),
            "skill_level": random.randint(1, 450),
        }


@register_log_type(
    name="economy.repair_cost",
    category=LogCategory.ECONOMY,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Equipment repair",
    text_template="[{timestamp}] REPAIR: {char_name} repaired equipment for {cost}g (durability: {durability_restored}%)",
)
class EconomyRepairCostGenerator(BaseLogGenerator):
    """Generates repair cost log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "cost": random.randint(5, 200),
            "durability_restored": random.randint(10, 100),
            "items_repaired": random.randint(1, 16),
            "zone": generate_zone(),
        }


@register_log_type(
    name="economy.tax_collected",
    category=LogCategory.ECONOMY,
    severity=LogSeverity.DEBUG,
    recurrence=RecurrencePattern.FREQUENT,
    description="Transaction tax collected",
    text_template="[{timestamp}] TAX: {amount}g collected from {char_name} ({type})",
)
class EconomyTaxCollectedGenerator(BaseLogGenerator):
    """Generates tax collection log entries."""

    TAX_TYPES = [
        "auction_fee", "auction_cut", "mail_fee", "guild_bank_fee",
        "respec_cost", "flight_cost",
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        tax_type = random.choice(self.TAX_TYPES)
        # Tax amounts vary by type
        amounts = {
            "auction_fee": (1, 100),
            "auction_cut": (1, 500),
            "mail_fee": (1, 5),
            "guild_bank_fee": (1, 10),
            "respec_cost": (10, 50),
            "flight_cost": (1, 20),
        }
        min_amt, max_amt = amounts.get(tax_type, (1, 10))

        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "amount": random.randint(min_amt, max_amt),
            "type": tax_type,
        }
