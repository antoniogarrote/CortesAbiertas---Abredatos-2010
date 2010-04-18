/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.cortesabiertas.datamining.classifier.builder;

import org.cortesabiertas.datamining.classifier.GateWorkflow;
import org.cortesabiertas.datamining.classifier.Word;
import gate.Annotation;
import gate.AnnotationSet;
import gate.Corpus;
import gate.Document;
import gate.Factory;
import gate.creole.ResourceInstantiationException;
import gate.util.InvalidOffsetException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedList;
import java.util.List;

/**
 * Describes TopWordsExtractor
 *
 *
 * Created: Wed Nov 23 21:16:29 2008
 *
 * @author <a href="mailto:antoniogarrote@gmail.com">Antonio Garrote Hernandez</a>
 * @version 1.0
 */
public class TopWordsExtractor {

    private static TopWordsExtractor instance;

    public static TopWordsExtractor instance() throws ResourceInstantiationException {
        if(TopWordsExtractor.instance==null) {
            TopWordsExtractor.instance = new TopWordsExtractor();
        }

        return instance;
    }
    private GateWorkflow workflow;
    private Corpus corpus;

    public TopWordsExtractor() throws ResourceInstantiationException {
        workflow = GateWorkflow.instance();

        Document doc = Factory.newDocument("Esto no es una prueba de documento. Es tan sólo un documento más que quiero probar a clasificar.");
        corpus = Factory.newCorpus("top words extractor corpus");
    }

    public void clear() {
        Word.clear();
    }

    public ArrayList<Word> extract(String data) throws Exception {
        corpus.clear();
        Document doc = Factory.newDocument(data);
        corpus.add(0,doc);
        workflow.executeOnCorpus(corpus);
        return computeMostFrequentWords(doc);
    }

    private ArrayList<Word> computeMostFrequentWords(Document doc) throws InvalidOffsetException {
        System.out.println("Computing most frequent words...");
        StringBuffer summary = new StringBuffer();
        ArrayList<String> stopWords = new ArrayList<String>();

        for(Annotation anot : doc.getAnnotations().get("Lookup")) {
            long start_pos = anot.getStartNode().getOffset();
            long end_pos = anot.getEndNode().getOffset();
            String tkey = doc.getContent().getContent(start_pos, end_pos).toString();
            //System.out.println("found stop word"+tkey);
            if(!stopWords.contains(tkey)) {
                //System.out.println("Stop word added");
                stopWords.add(tkey);
            }
        }
        Word.stopsTxt = stopWords;


        AnnotationSet tokens = doc.getAnnotations().get("Token");
        Object[] tokensArray = tokens.toArray();
        //System.out.println("Found "+tokensArray.length+" tokens");
        Arrays.sort(tokensArray, new Comparator(){
                public int compare(Object o1, Object o2) {
                    Annotation anot1 = (Annotation) o1;
                    Annotation anot2 = (Annotation) o2;
                    if(anot1.getStartNode().getOffset()<anot2.getStartNode().getOffset()) {
                        return -1;
                    } else if(anot1.getStartNode().getOffset()>anot2.getStartNode().getOffset()) {
                        return 1;
                    } else {
                        return 0;
                    }
                }
            });

        Word.document = doc;

        for(Object oa : tokensArray) {
            Annotation anot = (Annotation) oa;
            Word.update(anot);
        }


        Collection<Word> theWordsCollection = Word.words.values();
        List<Word> theWords = new LinkedList(theWordsCollection);
        Collections.sort(theWords, new Comparator<Word>() {
            public int compare(Word o1, Word o2) {
                if (o1.getOccurences() > o2.getOccurences()) {
                    return 1;
                } else if (o1.getOccurences() < o2.getOccurences()) {
                    return -1;
                } else {
                    return 0;
                }
            }
        });

        Collections.sort(theWords, new Comparator<Word>() {

            public int compare(Word o1, Word o2) {
                if (o1.getOccurences() < o2.getOccurences()) {
                    return 1;
                } else if (o1.getOccurences() > o2.getOccurences()) {
                    return -1;
                } else {
                    return 0;
                }
            }
        });
        
        return new ArrayList<Word>(theWords);
    }

}
