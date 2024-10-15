import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.AsyncTask
import android.util.Base64
import java.io.ByteArrayOutputStream
import java.io.InputStream
import java.net.HttpURLConnection
import java.net.URL

class ImageToBase64Converter(private val apiKey: String) : AsyncTask<String, Void, String?>() {

  override fun doInBackground(vararg params: String): String? {
    val imageUrl = params[0]
    return try {
      val url = URL(imageUrl)
      val connection = url.openConnection() as HttpURLConnection
      connection.doInput = true

      // Add the X-Api-Key header using the apiKey passed as a parameter
      connection.setRequestProperty("X-Api-Key", apiKey)

      connection.connect()
      val input: InputStream = connection.inputStream
      val bitmap: Bitmap = BitmapFactory.decodeStream(input)

      val byteArrayOutputStream = ByteArrayOutputStream()
      bitmap.compress(Bitmap.CompressFormat.JPEG, 100, byteArrayOutputStream)
      val byteArray: ByteArray = byteArrayOutputStream.toByteArray()
      Base64.encodeToString(byteArray, Base64.DEFAULT)

    } catch (e: Exception) {
      e.printStackTrace()
      null
    }
  }

  override fun onPostExecute(base64Image: String?) {
    // Handle the base64 image result here if needed
  }
}
