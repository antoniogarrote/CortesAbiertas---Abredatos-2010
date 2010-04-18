package org.cortesabiertas.datamining.classifier;

import org.cortesabiertas.datamining.classifier.builder.TopWordsExtractor;
import java.util.ArrayList;

/**
 * Describe class Classifier
 *
 *
 * Created: Wed Nov 19 21:14:35 2008
 *
 * @author <a href="mailto:antoniogarrote@gmail.com">Antonio Garrote Hernandez</a>
 * @version 1.0
 */
public class Classifier {

    private GateWorkflow workflow;

    /**
     * Creates a new <code>Classifier</code> instance.
     *
     */
    public Classifier() throws Exception {
        ArrayList<Word> words = TopWordsExtractor.instance().extract("Esto no es una prueba de documento bonito. Es tan sólo un documento más que quiero probar a clasificar.");
        for(Word w : words) {
            System.out.println("Stem: "+w.txt+" occurences: "+w.getOccurences());
        }
    }

    

    public static void main(String[] args) {
        try {
            Classifier clas = new Classifier();
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
            for(StackTraceElement elm : ex.getStackTrace()) {
                System.out.println(elm.toString());
            }
            System.out.println("Casco...");
        }
    }
}
