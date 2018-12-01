package qicoo

import io.gatling.core.Predef._
import io.gatling.http.Predef._

class QicooRead extends Simulation {

    object Configuration {
        var SCENARIO_NAME = "Qicoo List"
        var REQUEST_NAME = "List Questions"
        var PATH = "/v1/jkd1812/questions"

        val BASE_URL = System.getProperty("baseUrl", "https://api-s.qicoo.tokyo")
        val USERS : Long = java.lang.Long.valueOf(System.getProperty("users", "12"))
        val DURING : Int = java.lang.Integer.valueOf(System.getProperty("during", "12"))
        val PARAM_START = System.getProperty("start", "1")
        val PARAM_END = System.getProperty("end", "100")
        val PARAM_SORT = System.getProperty("sort", "created_at")
        val PARAM_ORDER = System.getProperty("order", "desc")

        val URL = BASE_URL + PATH
    }

    val get2productpage = scenario(Configuration.SCENARIO_NAME)
        .exec(
            http(Configuration.REQUEST_NAME)
            .get(Configuration.URL)
            .queryParamSeq(Seq(
                    ("start", Configuration.PARAM_START),
                    ("end", Configuration.PARAM_END),
                    ("sort", Configuration.PARAM_SORT),
                    ("order", Configuration.PARAM_ORDER)
                ))
        ).pause(1)

    var httpProtocol = http
        .acceptHeader("application/json")
        .header("Cache-Control", "max-age=0")
        .connectionHeader("keep-alive")

    setUp(
        get2productpage.inject(Seq(
                rampUsersPerSec(1).to(Configuration.USERS).during(Configuration.DURING / 3),
                constantUsersPerSec(Configuration.USERS) during(Configuration.DURING / 3),
                rampUsersPerSec(Configuration.USERS).to(1).during(Configuration.DURING / 3)
            ))
    ).protocols(httpProtocol)

}