import Array "mo:base/Array";
import Hash "mo:base/Hash";

import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Option "mo:base/Option";

actor TaxPayerManager {
    private stable var taxPayersEntries : [(Text, TaxPayer)] = [];
    private var taxPayers = HashMap.HashMap<Text, TaxPayer>(0, Text.equal, Text.hash);

    public type TaxPayer = {
        tid: Text;
        firstName: Text;
        lastName: Text;
        address: Text;
    };

    system func preupgrade() {
        taxPayersEntries := Iter.toArray(taxPayers.entries());
    };

    system func postupgrade() {
        taxPayers := HashMap.fromIter<Text, TaxPayer>(taxPayersEntries.vals(), 0, Text.equal, Text.hash);
    };

    public func addTaxPayer(tp: TaxPayer) : async () {
        taxPayers.put(tp.tid, tp);
    };

    public query func getAllTaxPayers() : async [TaxPayer] {
        Iter.toArray(taxPayers.vals())
    };

    public query func searchTaxPayer(tid: Text) : async ?TaxPayer {
        taxPayers.get(tid)
    };
}
