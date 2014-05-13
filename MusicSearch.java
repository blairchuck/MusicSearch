U 


//read content
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.net.*;
import org.json.XML;
import org.json.JSONObject;
import org.json.JSONException;
import java.util.Iterator;
import java.util.List;
import org.w3c.dom.NodeList;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.jdom.output.XMLOutputter;
import org.jdom.output.Format;
import org.jdom.xpath.XPath;
import net.sf.json.JSON;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import net.sf.json.xml.XMLSerializer;
public class MusicSearch extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response)
    throws IOException, ServletException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/xml; charset=UTF-8");
        String title = request.getParameter("title_input");
        String titleType = request.getParameter("type");
        JSONObject xmlJSONObj; 
        String json;
        PrintWriter out = response.getWriter();
              
        try{
            String theCGI = "http://cs-server.usc.edu:28851/cgi-bin/get_discography_hw8.pl?";
            String theEncoded = "title=" + URLEncoder.encode(title,"UTF-8") + "&title_type=" + URLEncoder.encode(titleType);
			//String theEncoded = "title=" + title + "&title_type=" + titleType;
            URL url = new URL(theCGI + theEncoded);            
            URLConnection connection = url.openConnection();
            urlConnection.setAllowUserInteraction(false); 
			connection.setRequestProperty("Accept-Charset", "UTF-8");
            InputStream urlStream = url.openStream();
    
            
            xmlJSONObj = XML.toJSONObject(urlStream);
            json = xmlJSONObj.toString(2);
            out.println(json);            
                        
        } catch (MalformedURLException me) {
            System.err.println("MalformedURLException: " + me);
        } catch (IOException ioe) {
            System.err.println("IOException: " + ioe);
        } catch (JSONException je) {
            System.out.println(je.toString());
        }
    
    }
    public static void outputDocument(Document document) {
	Format format = Format.getPrettyFormat(); 
	format.setIndent(" ");
	format.setExpandEmptyElements(false);
	try {
	   XMLOutputter outputter = new XMLOutputter(format);
	   outputter.output(document, System.out);
	} catch (Exception e) {
	   e.printStackTrace();
	}
}