package  com.assentifysdk
import com.facebook.react.bridge.ReactApplicationContext

object ReactApplicationContextObject {
    private lateinit var reactApplicationContext: ReactApplicationContext
    fun setReactApplicationContextObject(reactApplicationContext: ReactApplicationContext) {
        this.reactApplicationContext = reactApplicationContext;
    }

    fun getReactApplicationContextObject(): ReactApplicationContext {
        return this.reactApplicationContext
    }

}
