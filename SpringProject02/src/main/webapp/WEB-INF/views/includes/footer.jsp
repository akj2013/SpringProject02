<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
        <!-- /#page-wrapper -->

    </div>
    <!-- /#wrapper -->

    <!-- Core Scripts - Include with every page -->
    <script src="/spring/resources/js/jquery-1.10.2.js"></script>
    <script src="/spring/resources/js/bootstrap.min.js"></script>
    <script src="/spring/resources/js/bootstrap.js"></script>
    <script src="/spring/resources/js/plugins/metisMenu/jquery.metisMenu.js"></script>

    <!-- Page-Level Plugin Scripts - Tables -->
    <script src="/spring/resources/js/plugins/dataTables/jquery.dataTables.js"></script>
    <script src="/spring/resources/js/plugins/dataTables/dataTables.bootstrap.js"></script>

    <!-- SB Admin Scripts - Include with every page -->
    <script src="/spring/resources/js/sb-admin.js"></script>

    <!-- Page-Level Demo Scripts - Tables - Use for reference -->

	<script>
		$(document).ready(function() {
			$('#dataTables-example').DataTable({responsive: true});
			$('.sidebar-nav')
				.attr("class","sidebar-nav navbar-collapse collapse")
				.attr("aria-expanded",'false')
				.attr("style","height:1px");
		});
	</script>
</body>