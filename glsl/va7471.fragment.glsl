#ifdef GL_ES
precision mediump float;
#endif

//Noise test by Gravityloss

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float sharpnoise(vec2 pos)
{
	float value=0.0;
	if(mod(100.43*sin(pos.x*121.2311-cos(pos.y*42334.223)),1.0)>0.9)
	{
		value=1.0;
	}
	
	return value;
	
}

float smoothnoise(vec2 pos)
{
	return mod(100.43*(sin(pos.x*121.2311-cos(pos.y*42334.223))),1.0)-0.5;	
	//return ceil(mod(pos.x+pos.y,0.4));
}

float tilenoise(vec2 pos, float tilesize)
{
	return smoothnoise(tilesize*floor(pos/tilesize));
}

float intertilenoise(vec2 pos, float tilesize)
{
	float value = tilenoise(pos,tilesize);
	vec2 tilecenter = tilesize*floor(pos/tilesize)+0.5*tilesize;
	vec2 delta = pos-tilecenter;
	vec2 nextcenter = pos+ceil(delta/tilesize)*tilesize;
	float nextvalue = tilenoise(nextcenter,tilesize);
	float inter = length(delta)/tilesize;
	float returnvalue=inter*nextvalue;
	returnvalue += (1.0-inter)*value;
	return returnvalue;
}


void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - mouse / 1.0;

	float color = 0.5;

	color+=0.5*intertilenoise(position,0.1);
	color+=0.4*intertilenoise(position,0.05);
	color+=0.3*tilenoise(position,0.025);
	color+=0.2*tilenoise(position,0.0125);
	color+=0.2*tilenoise(position,0.00625);
	color+=0.1*tilenoise(position,2./resolution.x);
	color+=0.1*tilenoise(position,1./resolution.x);
	
	gl_FragColor = vec4( vec3( 0.5 * color, color * 0.5, color), 1.0 );
}