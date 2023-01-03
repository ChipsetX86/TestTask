function makeRequest(modelCurrency)
{
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var json = JSON.parse(doc.responseText.toString());
            modelCurrency.clear()
            for(var key in json.bpi) {
               modelCurrency.append({"name":key});
            }

        }
    }

    doc.open("GET", "https://api.coindesk.com/v1/bpi/currentprice.json");
    doc.send();
}

function dbGetHandle() {
   return LocalStorage.openDatabaseSync("CurrencyDB", "", "Database", 1000000);
}

function createDB() {
    var db = dbGetHandle();
    db.transaction(
        function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS Comments(id TEXT, comment TEXT, PRIMARY KEY (id))');
         }
     )

    console.log("create DB")
}

function saveComment(id, comment) {
    if (comment.length == 0) {
        return;
    }
    var db = dbGetHandle();
    db.transaction(
        function(tx) {
            var rs = tx.executeSql('SELECT * FROM Comments WHERE id = ?', [id]);
            if (rs.rows.length === 0) {
                tx.executeSql('INSERT INTO Comments VALUES(?, ?)', [id, comment]);
            } else {
                tx.executeSql('UPDATE Comments SET comment = ? WHERE id = ?', [comment, id]);
            }
         }
     )
}

function getComment(id) {
    var db = dbGetHandle();
    var text = "";
    db.transaction(
       function(tx) {
            var rs = tx.executeSql('SELECT * FROM Comments WHERE id = ?', [id]);
            if (rs.rows.length == 0) {
                text = "";
            } else {
                text = rs.rows.item(0).comment;
            }
         }
     )
     return text;
}
