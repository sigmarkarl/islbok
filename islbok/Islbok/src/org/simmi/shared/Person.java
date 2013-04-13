package org.simmi.shared;

import java.io.Serializable;
import java.util.Collection;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;


public class Person implements Serializable {
	private static final long serialVersionUID = 6226445402443113097L;
	
	String	name;
	int		gender;
	Date	dob;
	String	dateOfBirth;
	String	comment;
	String	key;
	String	islbokid;
	String	islbokuser;
	String	islbokpass;
	String	facebookid;
	String	facebookusername;
	String	fbwriter;
	String	geocode;
	String	imgurl;
	String	session;
	
	public String getIslbokid() {
		return islbokid;
	}

	public void setIslbokid(String islbokid) {
		this.islbokid = islbokid;
	}

	public String getIslbokuser() {
		return islbokuser;
	}

	public void setIslbokuser(String islbokuser) {
		this.islbokuser = islbokuser;
	}

	public String getIslbokpass() {
		return islbokpass;
	}

	public void setIslbokpass(String islbokpass) {
		this.islbokpass = islbokpass;
	}
	
	public String getFacebookid() {
		return facebookid;
	}

	public void setFacebookid(String facebookid) {
		this.facebookid = facebookid;
	}
	
	public String getFacebookUsername() {
		return facebookusername;
	}

	public void setFacebookUsername(String facebookusername) {
		this.facebookusername = facebookusername;
	}

	public String getFbwriter() {
		return fbwriter;
	}

	public void setFbwriter(String fbwriter) {
		this.fbwriter = fbwriter;
	}

	public String getSession() {
		return session;
	}

	public void setSession(String session) {
		this.session = session;
	}
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getGender() {
		return gender;
	}

	public void setGender( int gender) {
		this.gender = gender;
	}

	public String getDateOfBirth() {
		return dateOfBirth;
	}
	
	public String getDateOfBirthHR() {
		String hr = dateOfBirth;
		if(dateOfBirth.length() == 8)
		{
			hr = dateOfBirth.substring(6,8) + " / " + dateOfBirth.substring(4,6) + " / " + dateOfBirth.substring(0,4);  
		}
		else if(dateOfBirth.length() == 6)
		{
			hr = dateOfBirth.substring(4,6) + " / " + dateOfBirth.substring(0,4);
		}

		return hr;
	}

	public void setDateOfBirth(String dateOfBirth) {
		this.dateOfBirth = dateOfBirth;
	}
	
	public Date getDob() {
		return dob;
	}
	
	public void setDob( Date dob ) {
		this.dob = dob;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public Person() {
		//children = new HashSet<Person>();
		//siblings = new HashSet<Person>();
	}
	
	public Person( String name, Date dob, int gender ) {
		this();
		this.name = name;
		this.gender = gender;
		this.dob = dob;
	}
	
	public Person( String name, String dateOfBirth, int gender ) {
		this();
		this.name = name;
		this.gender = gender;
		this.dateOfBirth = dateOfBirth;
	}
	
	Person			father;
	Person			mother;
	Collection<Person>		children;
	Collection<Person>		siblings;
	Collection<Person>		mates;
	
	public boolean isMale() {
		return gender == 1;
	}
	
	public boolean isFemale() {
		return gender == 2;
	}
	
	public Person getFather() {
		return father;
	}
	
	public Person getMother() {
		return mother;
	}
	
	public Collection<Person> getChildren() {
		return children;
	}
	
	public void setFather( Person father ) {
		if( this.father != null ) {
			father.addChildren( this.father.getChildren() );
		}
		this.father = father;
		father.addChild( this );
	}
	
	public void setMother( Person mother ) {
		if( this.mother != null ) {
			mother.addChildren( this.mother.getChildren() );
		}
		this.mother = mother;
		mother.addChild( this );
	}
	
	public void setParent( Person parent ) {
		if( parent.isMale() ) setFather( parent );
		else setMother( parent );
	}
	
	public void setChildren( Collection<Person> children ) {
		this.children = children;
	}
	
	public void addChildren( Collection<Person> newchildren ) {
		if( this.children == null ) this.children = new HashSet<Person>();
		if( newchildren != null ) this.children.addAll( newchildren );
	}
	
	public boolean addChild( Person child ) {
		if( children == null ) children = new HashSet<Person>();
		if( children.add( child ) ) {
			child.setParent( this );
			return true;
		}
		
		return false;
	}
	
	public Collection<Person> getMates() {
		return mates;
	}
	
	public void setMates( Collection<Person> mates ) {
		this.mates = mates;
	}
	
	public void addMates( Collection<Person> newmates ) {
		if( this.mates == null ) this.mates = new HashSet<Person>();
		if( newmates != null ) this.mates.addAll( newmates );
	}
	
	public boolean addMate( Person mate ) {
		if( mates == null ) mates = new HashSet<Person>();
		if( mates.add( mate ) ) {
			mate.addMate( this );
			return true;
		}
		
		return false;
	}
	
	public Collection<Person> getSiblings() {
		return siblings;
	}
	
	public void setSiblings( Collection<Person> siblings ) {
		this.siblings = siblings;
	}
	
	@Override
	public boolean equals( Object other ) {
		if( other!= null ) {
			Person otherPerson = (Person)other;
			return this.getIslbokid().equals(otherPerson.getIslbokid()) || this.getFacebookid().equals(otherPerson.getFacebookid()) || this.getKey().equals(otherPerson.getKey());
		}
		
		return false;
	}
	
	public void addSiblings( Collection<Person> newsiblings ) {
		if( this.siblings == null ) this.siblings = new HashSet<Person>();
		if( newsiblings != null ) this.siblings.addAll( newsiblings );
	}
	
	public void addSibling( Person sibling ) {
		if( siblings == null ) siblings = new HashSet<Person>();
		if( !this.equals(sibling) && siblings.add( sibling ) ) sibling.addSibling( this );
	}
	
	public int hashCode() {
		return super.hashCode();
	}
}
