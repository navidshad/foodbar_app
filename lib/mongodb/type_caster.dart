class TypeCaster
{
	String type;
	String path;

	TypeCaster(this.type, this.path);

	Map getMap()
	{
		return {
			'type': type,
			'path': path
		};
	}
}