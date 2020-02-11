import 'type_caster.dart';

class AggregatePiplines 
{
	String title;
	String database;
	String collection;
	bool addCountAsLastPipline;
	
	List<Map> piplines;
	List<TypeCaster> types;

	AggregatePiplines({
		this.title, this.database, this.collection, 
		this.addCountAsLastPipline=false, 
		this.piplines=const[], this.types=const[]
		})
	{
		if(addCountAsLastPipline) addCountPipline();
	}

	void addCountPipline()
	{
		Map countPipline = { "\$count": "count" };
		piplines.add(countPipline);
	}
}