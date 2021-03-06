package org.simmi.server;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.simmi.client.FrislbokService;
import org.simmi.shared.Person;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.PreparedQuery;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.api.datastore.Query.FilterPredicate;
import com.google.gwt.user.server.rpc.RemoteServiceServlet;

public class FrislbokServiceImpl extends RemoteServiceServlet implements FrislbokService {
	private static final long serialVersionUID = 1L;
	
	public static Map<String,Person>	sessionPerson = new HashMap<String,Person>();

	@Override
	public Person fetchFromFacebookId(String uid) {
		Person retPerson = null;
		
		//this.getThreadLocalRequest().getSession().
		
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Query query = new Query("person");
		FilterPredicate	filter = new FilterPredicate("islbokid", FilterOperator.EQUAL, uid);
		query.setFilter( filter );
		PreparedQuery pq = datastore.prepare( query );
		List<Entity> personEntities = pq.asList( FetchOptions.Builder.withDefaults() );
		
		if( personEntities.size() > 0 ) {
			Entity 	e = personEntities.get(0);
			String 	name = (String)e.getProperty("name");
			String 	dateOfBirth = (String)e.getProperty("dateofbirth");
			Long 	gender = (Long)e.getProperty("gender");
			String	comment = (String)e.getProperty("comment");
			//String	fatherKey = (String)e.getProperty("father");
			//String	motherKey = (String)e.getProperty("mother");
			String	fbuser = (String)e.getProperty("fbuser");
			String	fbwriter = (String)e.getProperty("fbwriter");
			
			retPerson = new Person( name, dateOfBirth, gender.intValue() );
			retPerson.setComment( comment );
			retPerson.setKey( KeyFactory.keyToString(e.getKey()) );
			retPerson.setFacebookid( uid );
			retPerson.setFacebookUsername( fbuser );
			retPerson.setFbwriter( fbwriter );
			
			return retPerson;
		}
		
		return retPerson;
	}

	@Override
	public Person fetchFromKeyString(String key) {
		Person[] persons = fetchFromKeyStringArray( new String[] { key } );
		if( persons.length > 0 ) return persons[0];
		
		return null;
	}

	@Override
	public Person[] fetchFromKeyStringArray(String[] keys) {		
		Set<Key>	keySet = new HashSet<Key>();
		for( String keystr : keys ) keySet.add( KeyFactory.stringToKey(keystr) );
		return fetchFromKeySet( keySet );
	}	
	
	private Person[] fetchFromKeySet( Set<Key>	keyset ) {
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Map<Key,Entity> entityMap = datastore.get( keyset );
		
		/*Query query = new Query("person");
		query.addFilter("key", FilterOperator.IN, keys);
		PreparedQuery pq = datastore.prepare( query );
		List<Entity> personEntities = pq.asList( FetchOptions.Builder.withDefaults() );*/
		
		int i = 0;
		Person[] persons = new Person[ entityMap.size() ];
		for( Key key : entityMap.keySet() ) {
			Entity e = entityMap.get(key);
			
			String 	name = (String)e.getProperty("name");
			String 	dateOfBirth = (String)e.getProperty("dateofbirth");
			Long 	gender = (Long)e.getProperty("gender");
			String	comment = (String)e.getProperty("comment");
			//String	fatherKey = (String)e.getProperty("father");
			//String	motherKey = (String)e.getProperty("mother");
			
			Person retPerson = new Person( name, dateOfBirth, gender.intValue() );
			retPerson.setComment( comment );
			retPerson.setKey( KeyFactory.keyToString(e.getKey()) );
			
			i++;
		}
		return persons;
	}

	@Override
	public String savePerson(Person person) {
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		String keystr = person.getKey();
		
		Entity e;
		if( keystr == null ) {
			e = new Entity("person");			
		} else {
			try {
				e = datastore.get( KeyFactory.stringToKey( keystr ) );
			} catch (EntityNotFoundException e1) {
				e = new Entity("person");
			}
		}
		e.setProperty("name", person.getName());
		e.setProperty("dateofbirth", person.getDateOfBirth());
		e.setProperty("gender", person.getGender());
		e.setProperty("fbwriter", person.getFbwriter());
		e.setProperty("facebookid", person.getFacebookid());
		e.setProperty("facebookusername", person.getFacebookUsername());
		e.setProperty("comment", person.getComment());
		
		Person father = person.getFather();
		if( father != null && father.getKey() != null ) e.setProperty( "father", father.getKey() );
		Person mother = person.getMother();
		if( mother != null && mother.getKey() != null ) e.setProperty( "mother", mother.getKey() );
		
		Set<String>	childIds = new HashSet<String>();
		for( Person child : person.getChildren() ) childIds.add( child.getKey() );
		e.setProperty("children", childIds);
		
		Set<String>	sibIds = new HashSet<String>();
		for( Person sibling : person.getSiblings() ) sibIds.add( sibling.getKey() );
		e.setProperty("siblings", sibIds);

		datastore.put( e );
		
		return KeyFactory.keyToString( e.getKey() );
	}

	@Override
	public String savePersonArray(Person[] persons) {
		for( Person person : persons ) {
			savePerson( person );
		}
		
		return null;
	}
	
	public Person[] parseIslbokPersonArray( String jsonPersonArray ) {
		JSONArray 	jsonarr = (JSONArray)JSONValue.parse( jsonPersonArray );
		
		Person[] persons = new Person[ jsonarr.size() ];
		for( int i = 0; i < jsonarr.size(); i++ ) {
			JSONObject jsonobj = (JSONObject)jsonarr.get(i);
			//JSONObject jsonobj = jsonvalue.isObject();
			persons[i] = parseIslbokPerson( jsonobj );
		}
		return persons;
	}
	
	public Person parseIslbokPerson( JSONObject jsonobj ) {
		String name = (String)jsonobj.get("name");
		
		String dob = (String)jsonobj.get("dob");
		long gender = (Long)jsonobj.get("gender");
		String text = (String)jsonobj.get("text");
		long id = (Long)jsonobj.get("id");
		
		Long motherislbokid = (Long)jsonobj.get("mother");
		Long fatherislbokid = (Long)jsonobj.get("father");
		
		//String namestr = name.stringValue();
		int genderval = (int)( gender );
		final Person person = new Person( name, dob, genderval );
		person.setIslbokid( Long.toString(id) );
		person.setComment( text );
		
		Person father = new Person();
		father.setGender( 1 );
		father.setIslbokid( Long.toString(fatherislbokid) );	
		person.setParent( father );
		Person mother = new Person();
		mother.setGender( 2 );
		mother.setIslbokid( Long.toString(motherislbokid) );
		person.setParent( mother );
		
		return person;
	}
	
	public Person parseIslbokPerson( String jsonPerson ) {
		if( jsonPerson != null ) {
			//JSON
			JSONObject	jsonobj = (JSONObject)JSONValue.parse( jsonPerson );
			//JSONValue 	jsonval = JSONParser.parseLenient( jsonPerson );
			//JSONObject 	jsonobj = jsonval.isObject();
			return parseIslbokPerson( jsonobj );
		}
		return null;
	}

	String cookiestr = "";
	
	public String getCookieString() {
		return cookiestr;
	}
	
	public void setCookieString( String cookiestr ) {
		this.cookiestr = cookiestr;
	}
	
	@Override
	public String login(String user, String password) {
		try {
			String query = "login?user="+user+"&pwd="+URLEncoder.encode( password, "UTF8" );
			//String query = URLEncoder.encode( stuff, "UTF8" );
			URL url = new URL( "http://www.islendingabok.is/ib_app/"+query );
			URLConnection uc = url.openConnection();
			uc.connect();
			
			String headerName=null;
			for (int i=1; (headerName = uc.getHeaderFieldKey(i))!=null; i++) {
			 	//this.log( headerName );
				if (headerName.equalsIgnoreCase("Set-Cookie")) {               
			 		String cookie = uc.getHeaderField(i);
			 		cookie = cookie.substring(0, cookie.indexOf(";"));
			 		//String cookieName = cookie.substring(0, cookie.indexOf("="));
			 		//String cookieValue = cookie.substring(cookie.indexOf("=") + 1, cookie.length());
			 		if( cookiestr.length() == 0 ) cookiestr = cookie;
			 		else cookiestr += "; "+cookie;
			 	}
			}
			//System.err.println( query );
			InputStream is = uc.getInputStream();
			ByteArrayOutputStream	baos = new ByteArrayOutputStream();
			
			int c = is.read();
			while( c != -1 ) {
				baos.write( c );
				c = is.read();
			}
			is.close();
			return baos.toString();
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public String islbok_get(String session, String id) {
		try {
			String query = "get?session="+session+"&id="+id;
			//String query = URLEncoder.encode( stuff, "UTF8" );
			String urlstr = "http://www.islendingabok.is/ib_app/"+query;
			
			URL url = new URL( urlstr );
			URLConnection urlconn = url.openConnection();
			if( cookiestr != null ) {
				//this.log("ok "+cookies.length);
				//this.log(cookiestr);
				urlconn.setRequestProperty("Cookie", cookiestr);
			}
			InputStream is = urlconn.getInputStream();
			ByteArrayOutputStream	baos = new ByteArrayOutputStream();
			
			int c = is.read();
			while( c != -1 ) {
				baos.write( c );
				c = is.read();
			}
			is.close();
			return baos.toString( "iso-8859-1" );
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	@Override
	public String islbok_find( String session, String name, String dob ) {
		try {
			String query = "find?session="+session;
			if( name != null && name.length() > 0 ) query += "&name="+URLEncoder.encode( name , "ISO-8859-1");
			if( dob != null && dob.length() > 0 ) query += "&dob="+dob;
			//String query = URLEncoder.encode( stuff, "UTF8" );
			String urlstr = "http://www.islendingabok.is/ib_app/"+query;
			
			URL url = new URL( urlstr );
			URLConnection urlconn = url.openConnection();
			if( cookiestr != null ) {
				//this.log("ok "+cookies.length);
				//this.log(cookiestr);
				urlconn.setRequestProperty("Cookie", cookiestr);
			}
			InputStream is = urlconn.getInputStream();
			ByteArrayOutputStream	baos = new ByteArrayOutputStream();
			
			int c = is.read();
			while( c != -1 ) {
				baos.write( c );
				c = is.read();
			}
			is.close();
			return baos.toString( "iso-8859-1" );
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public String islbok_children(String session, String id) {
		try {
			String query = "children?session="+session+"&id="+id;
			//String query = URLEncoder.encode( stuff, "UTF8" );
			String urlstr = "http://www.islendingabok.is/ib_app/"+query;
			
			URL url = new URL( urlstr );
			URLConnection urlconn = url.openConnection();
			if( cookiestr != null ) {
				//this.log("ok "+cookies.length);
				urlconn.setRequestProperty("Cookie", cookiestr);
			}
			InputStream is = urlconn.getInputStream();
			ByteArrayOutputStream	baos = new ByteArrayOutputStream();
			
			int c = is.read();
			while( c != -1 ) {
				baos.write( c );
				c = is.read();
			}
			is.close();
			String ret = baos.toString( "iso-8859-1" );
			
			System.err.println("query " + id + " " + ret );
			
			return ret;
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	@Override
	public String islbok_mates(String session, String id) {
		try {
			String query = "mates?session="+session+"&id="+id;
			//String query = URLEncoder.encode( stuff, "UTF8" );
			String urlstr = "http://www.islendingabok.is/ib_app/"+query;
			
			URL url = new URL( urlstr );
			URLConnection urlconn = url.openConnection();
			if( cookiestr != null ) {
				//this.log("ok "+cookies.length);
				urlconn.setRequestProperty("Cookie", cookiestr);
			}
			InputStream is = urlconn.getInputStream();
			ByteArrayOutputStream	baos = new ByteArrayOutputStream();
			
			int c = is.read();
			while( c != -1 ) {
				baos.write( c );
				c = is.read();
			}
			is.close();
			String ret = baos.toString( "iso-8859-1" );
			
			System.err.println("query " + id + " " + ret );
			
			return ret;
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public Person fetchFromIslbokId(String islbokid) {
		Person retPerson = null;
		
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Query query = new Query("person");
		FilterPredicate	filter = new FilterPredicate("islbokid", FilterOperator.EQUAL, islbokid);
		query.setFilter( filter );
		PreparedQuery pq = datastore.prepare( query );
		List<Entity> personEntities = pq.asList( FetchOptions.Builder.withDefaults() );
		
		if( personEntities.size() > 0 ) {
			Entity 	e = personEntities.get(0);
			String 	name = (String)e.getProperty("name");
			String 	dateOfBirth = (String)e.getProperty("dateofbirth");
			Long 	gender = (Long)e.getProperty("gender");
			String	comment = (String)e.getProperty("comment");
			String	fatherKey = (String)e.getProperty("father");
			String	motherKey = (String)e.getProperty("mother");
			String	fbuser = (String)e.getProperty("fbuser");
			String	fbwriter = (String)e.getProperty("fbwriter");
			
			retPerson = new Person( name, dateOfBirth, gender.intValue() );
			retPerson.setComment( comment );
			retPerson.setKey( KeyFactory.keyToString(e.getKey()) );
			retPerson.setIslbokid( islbokid );
			retPerson.setFacebookUsername( fbuser );
			retPerson.setFbwriter( fbwriter );
			
			Person mother = new Person();
			mother.setKey( motherKey );
			retPerson.setMother( mother );
			Person father = new Person();
			father.setKey( fatherKey );
			retPerson.setFather( father );
			
			return retPerson;
		}
		
		return retPerson;
	}

	@Override
	public String islbok_siblings(String session, String id) {
		try {
			String query = "siblings?session="+session+"&id="+id;
			//String query = URLEncoder.encode( stuff, "UTF8" );
			String urlstr = "http://www.islendingabok.is/ib_app/"+query;
			
			URL url = new URL( urlstr );
			URLConnection urlconn = url.openConnection();
			if( cookiestr != null ) {
				//this.log("ok "+cookies.length);
				urlconn.setRequestProperty("Cookie", cookiestr);
			}
			InputStream is = urlconn.getInputStream();
			ByteArrayOutputStream	baos = new ByteArrayOutputStream();
			
			int c = is.read();
			while( c != -1 ) {
				baos.write( c );
				c = is.read();
			}
			is.close();
			return baos.toString( "iso-8859-1" );
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public String islbok_ancestors(String session, String id) {
		try {
			String query = "ancestors?session="+session+"&id="+id;
			//String query = URLEncoder.encode( stuff, "UTF8" );
			String urlstr = "http://www.islendingabok.is/ib_app/"+query;
			
			URL url = new URL( urlstr );
			URLConnection urlconn = url.openConnection();
			if( cookiestr != null ) {
				//this.log("ok "+cookies.length);
				this.log(cookiestr);
				urlconn.setRequestProperty("Cookie", cookiestr);
			}
			InputStream is = urlconn.getInputStream();
			ByteArrayOutputStream	baos = new ByteArrayOutputStream();
			
			int c = is.read();
			while( c != -1 ) {
				baos.write( c );
				c = is.read();
			}
			is.close();
			return baos.toString( "iso-8859-1" );
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public String islbok_trace(String session, String id) {
		try {
			String query = "trace?session="+session+"&id="+id;
			String urlstr = "http://www.islendingabok.is/ib_app/"+query;
			
			URL url = new URL( urlstr );
			URLConnection urlconn = url.openConnection();
			if( cookiestr != null ) {
				//this.log("ok "+cookies.length);
				//this.log(cookiestr);
				urlconn.setRequestProperty("Cookie", cookiestr);
			}
			InputStream is = urlconn.getInputStream();
			ByteArrayOutputStream	baos = new ByteArrayOutputStream();
			
			int c = is.read();
			while( c != -1 ) {
				baos.write( c );
				c = is.read();
			}
			is.close();
			return baos.toString( "iso-8859-1" );
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public ArrayList<ArrayList<Person>> parseIslbokPersonArrayTrace( String jsonPersonArray ) {
		JSONArray jsonarr = (JSONArray)JSONValue.parse( jsonPersonArray );

		ArrayList<ArrayList<Person>> persons = new ArrayList<ArrayList<Person>>();
		ArrayList<Person> personsLeft = new ArrayList<Person>();
		ArrayList<Person> personsRight = new ArrayList<Person>();

		for(int i = 0;i < jsonarr.size();i++)
		{
			JSONObject jsonobj = (JSONObject)jsonarr.get(i);
			Person temp = parseIslbokPerson( jsonobj );
			if(temp.getIslbokid().equals("-10"))
			{
				personsRight.add(temp);
			}
			else
			{
				personsLeft.add(temp);
			}
		}
		persons.add(personsLeft);
		persons.add(personsRight);
		return persons;
	}
}
