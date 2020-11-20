<%@include file="../init.jsp"%>

<%
    String keywords = ParamUtil.getString(request, "keywords");
    long guestbookId = ParamUtil.getLong(renderRequest, "guestbookId");
%>

<liferay-portlet:renderURL varImpl="searchURL">
    <portlet:param name="mvcPath"
                   value="/guestbookwebportlet/view_search.jsp" />
</liferay-portlet:renderURL>

<portlet:renderURL var="viewURL">
    <portlet:param
            name="mvcPath"
            value="/guestbookwebportlet/view.jsp"
    />
</portlet:renderURL>

<aui:form action="${searchURL}" name="fm">

    <liferay-ui:header backURL="${viewURL}" title="back" />

    <div class="row">
        <div class="col-md-8">
            <aui:input inlineLabel="left" label="" name="keywords" placeholder="search-entries" size="256" />
        </div>

        <div class="col-md-4">
            <aui:button type="submit" value="search" />
        </div>
    </div>
</aui:form>
<%
    System.out.println("here 00");

    SearchContext searchContext = SearchContextFactory.getInstance(request);
    System.out.println(searchContext.getKeywords());
    searchContext.setKeywords(keywords);
    System.out.println("here 12");
    searchContext.setAttribute("paginationType", "more");
    System.out.println("here 13");
    searchContext.setStart(0);
    System.out.println("here 14");
    searchContext.setEnd(10);
    System.out.println("here 15");

    Indexer indexer = IndexerRegistryUtil.getIndexer(Guestbook.class);
    System.out.println("here 16");

    System.out.println("indexer = " + indexer);

    Hits hits = indexer.search(searchContext);
    System.out.println("here 17");
    List<Entry> entries = new ArrayList<Entry>();
    System.out.println("here 18");

    for (int i = 0; i < hits.getDocs().length; i++) {
        Document doc = hits.doc(i);

        long entryId = GetterUtil.getLong(doc.get(Field.ENTRY_CLASS_PK));

        Entry entry = null;

        try {
            entry = EntryLocalServiceUtil.getEntry(entryId);
        } catch (PortalException pe) {
            _log.error(pe.getLocalizedMessage());
        } catch (SystemException se) {
            _log.error(se.getLocalizedMessage());
        }

        entries.add(entry);
    }
    System.out.println("here 19");

%>


<%!
    private static Log _log = LogFactoryUtil.getLog("html.guestbookwebportlet.view_search_jsp");
%>