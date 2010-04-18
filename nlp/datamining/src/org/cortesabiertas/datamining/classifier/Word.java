package org.cortesabiertas.datamining.classifier;

import java.util.ArrayList;
import java.util.HashMap;

import gate.Document;
import gate.Annotation;
import gate.util.InvalidOffsetException;

/**
 * Models a reference to a word, tracing the number of occurences of the word in a GATE document.
 *
 *
 * Created: Sun Nov 23 20:42:06 2008
 *
 * @author <a href="mailto:antoniogarrote@gmail.com">Antonio Garrote Hernandez</a>
 * @version 1.0
 */
public class Word {

    private Annotation word;
    private int occurences;
    private String stem;
    public String txt;
    private String pos;
    private String literal;
    public static Document document;

    public Word(Annotation anot, String stem, String txt, String pos, String literal) {
        this.word = anot;
        this.occurences = 1;
        this.txt = txt;
        this.stem = stem;
        this.pos = pos;
        this.literal = literal;
    }

    public Annotation getWord() {
        return word;
    }

    public void setWord(Annotation word) {
        this.word = word;
    }

    public int getOccurences() {
        return occurences;
    }

    public void setOccurences(int occurences) {
        this.occurences = occurences;
    }

    public void incrementOccurences() {
        this.occurences++;
    }

    public static HashMap<String,Word> words = new HashMap<String, Word>();
    public static ArrayList<Long> stops = new ArrayList<Long>();
    public static ArrayList<String> stopsTxt = new ArrayList<String>();

    public static void clear() {
        Word.words.clear();
    }

    public static void update(Annotation anot) throws InvalidOffsetException {
        //System.out.println("-------------------------------------");
        //System.out.println("TYPE:"+anot.getType());
        if(anot.getType().toString().equals("Token")){
            //System.out.println("KIND:"+anot.getFeatures().get("kind"));
            //System.out.println("STRING:"+anot.getFeatures().get("string"));
            //System.out.println("CATEGORY:"+anot.getFeatures().get("category"));
            //System.out.println("STEM:"+anot.getFeatures().get("stem"));
            String kind = (String) anot.getFeatures().get("kind");
            String key = (String) anot.getFeatures().get("string");
            String category = (String) anot.getFeatures().get("category");
            String stem = (String) anot.getFeatures().get("stem");
            String orth = (String) anot.getFeatures().get("orth");
            String len = (String) anot.getFeatures().get("lemma");

            if (kind.equals("word") && key != null && key.equals("") == false && category!=null && (category.equals("NC") || category.equals("ADJ")|| category.equals("VLfin"))&& !stopsTxt.contains(key)) {
                System.out.println("FOUND WORD");
                if (words.get(stem) == null) {
                    //System.out.println("NEW");
                    if(stopsTxt.contains(key)==false) {
                        //System.out.println("Adding word");
                        words.put(stem, new Word(anot,stem, len, category,key));
                    } else {
                        //System.out.println("Not adding cause in stop words");
                    }
                } else {
                    //System.out.println("NOT NEW");
                    words.get(stem).incrementOccurences();
                }
            }
        }
    }

    /**
     * @return the stem
     */
    public String getStem() {
        return stem;
    }

    /**
     * @param stem the stem to set
     */
    public void setStem(String stem) {
        this.stem = stem;
    }

    /**
     * @return the pos
     */
    public String getPos() {
        return pos;
    }

    /**
     * @param pos the pos to set
     */
    public void setPos(String pos) {
        this.pos = pos;
    }

    /**
     * @return the literal
     */
    public String getLiteral() {
        return literal;
    }

    /**
     * @param literal the literal to set
     */
    public void setLiteral(String literal) {
        this.literal = literal;
    }

}
