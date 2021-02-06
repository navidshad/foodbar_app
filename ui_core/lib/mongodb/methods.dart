// Map getNavigatorDetail({int total=10, int page=1, int perPage=5})
// {
// 	int _total_pages = (total/perPage).ceil();
// 	if(page > _total_pages) page = _total_pages;

// 	int from = 0;
// 	if(perPage == 1) from = page-1;
// 	else from = (perPage * page) - perPage;

// 	if (page <= 1) from = 0;

// 	Map result = {'pages': _total_pages, 'from':from, 'to':perPage};
// 	return result;
// }