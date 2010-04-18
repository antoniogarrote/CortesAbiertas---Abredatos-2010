package org.cortesabiertas.datamining.classifier;

import gate.Gate;
import gate.Corpus;
import gate.creole.annotdelete.AnnotationDeletePR;
import gate.treetagger.TreeTagger;
import gate.creole.tokeniser.DefaultTokeniser;
import gate.creole.splitter.SentenceSplitter;
import stemmer.SnowballStemmer;
import gate.creole.SerialAnalyserController;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * Describes a GATE resources workflow.
 *
 *
 * Created: Wed Nov 19 21:16:29 2008
 *
 * @author <a href="mailto:antoniogarrote@gmail.com">Antonio Garrote Hernandez</a>
 * @version 1.0
 */
public class GateWorkflow {

    private static GateWorkflow singleton;

    private SerialAnalyserController controller;

    public static GateWorkflow instance() {
        try {
            if(singleton == null) {
                singleton = new GateWorkflow();
            }
            return singleton;
        } catch(Exception e) {
            System.out.println(e.getMessage());

            return null;
        }
    }

    /**

     * Creates a new <code>GateWorkflow</code> instance.
     *
     */
    public GateWorkflow() throws Exception {

        ApplicationContext ctx = new ClassPathXmlApplicationContext("classifier.xml");

        // PR Resources
        /*
        AnnotationDeletePR prDocReset = (AnnotationDeletePR) ctx.getBean("prDocumentReset");
        TreeTagger prTreeTagger = (TreeTagger) ctx.getBean("prTreeTagger");
        SentenceSplitter prSentenceSplitter = (SentenceSplitter) ctx.getBean("prSentenceSplitter");
        DefaultTokeniser prDefaultTokeniser = (DefaultTokeniser) ctx.getBean("prDefaultTokeniser");
        SnowballStemmer prStemmer = (SnowballStemmer) ctx.getBean("prStemmer");
        */

        // ANNIE Serial controller
        controller = (SerialAnalyserController) ctx.getBean("serialController");
    }

    public void executeOnCorpus(Corpus corpus) throws Exception {
        controller.setCorpus(corpus);
        controller.execute();
    }

    public static void main(String[] args) {
        GateWorkflow g = GateWorkflow.instance();
        if(g==null) {
            System.out.println("\n\nALGO FUE MAL :( \n\n");
        }
    }
}
