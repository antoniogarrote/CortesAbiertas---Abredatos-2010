/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.cortesabiertas;

import org.cortesabiertas.datamining.classifier.Word;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.cortesabiertas.datamining.classifier.builder.TopWordsExtractor;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.commons.collections.map.ListOrderedMap;
import org.jcp.xml.dsig.internal.dom.ApacheCanonicalizer;
import org.springframework.metadata.commons.CommonsAttributes;

/**
 *
 * @author antonio.garrote
 */
public class textExtractor extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {

            // Retrieve the extractor
            ServletContext ctx = this.getServletContext();

            Object tmp = ctx.getAttribute("extractor");
            TopWordsExtractor twe = null;

            if (tmp == null) {
                twe = TopWordsExtractor.instance();
                ctx.setAttribute("extractor", twe);
            } else {
                twe = (TopWordsExtractor) tmp;
            }
            
            // Retrieve the body of the request
            StringBuilder stringBuilder = new StringBuilder();
            BufferedReader bufferedReader = null;
            try {
                InputStream inputStream = request.getInputStream();
                if (inputStream != null) {
                    bufferedReader = new BufferedReader(new InputStreamReader(
                            inputStream));
                    char[] charBuffer = new char[128];
                    int bytesRead = -1;
                    while ((bytesRead = bufferedReader.read(charBuffer)) > 0) {
                        stringBuilder.append(charBuffer, 0, bytesRead);
                    }
                } else {
                    stringBuilder.append("");
                }
            } catch (IOException ex) {
                throw ex;
            } finally {
                if (bufferedReader != null) {
                    try {
                        bufferedReader.close();
                    } catch (IOException ex) {
                        throw ex;
                    }
                }
            }
            String body = stringBuilder.toString();

            // Process the body
            /*System.out.println("EXTRACTING:" + body);
            body = body.replace('á', 'a');
            body = body.replace('é', 'e');
            body = body.replace('í', 'i');
            body = body.replace('ó', 'o');
            body = body.replace('ú', 'u');
            body = body.replace('ñ', 'n');
            body = body.replace('e', 'k');
            System.out.println("EXTRACTING AHORA:" + body);*/

            System.out.println("request...");
            twe.clear();
            ArrayList<Word> words =  twe.extract(body);
            //ArrayList<Word> words = twe.extract("Esto no es una prueba de documento. Es tan sólo un documento más que quiero probar a clasificar.");

            org.apache.commons.collections.map.ListOrderedMap lom = new ListOrderedMap();
            JSONArray array = new JSONArray();

            for(Word w : words) {
                JSONObject wjson = new JSONObject();
                wjson.element("count", w.getOccurences());
                wjson.element("lemma",w.txt);
                wjson.element("pos",w.getPos());
                wjson.element("stem", w.getStem());
                wjson.element("literal", w.getLiteral());
                array.add(wjson);
            }

            out.println(array);
            /* */
        } catch(Exception ex) {
            System.err.println(ex.getMessage());
            JSONObject res = new JSONObject();
            res.element("error", ex.getMessage());
            out.println(res);
        } finally { 
            out.close();
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
