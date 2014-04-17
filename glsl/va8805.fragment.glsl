#ifdef GL_ES
precision mediump float;
#endif
uniform vec2 resolution;
#define TILE_WIDTH 128.
#define ROOT3OVER2 (111./128.)
void main(){
	vec2 position = gl_FragCoord.xy;
	float x=position.x/TILE_WIDTH-.625,y=(resolution.y-position.y)/TILE_WIDTH-.5,//get allegro coords and divide by width (allegro numbers from top-left)
		u0=x*.5+y*ROOT3OVER2,v0=x*.5-y*ROOT3OVER2,w0=x,//get approx coordinates
		u=floor(.5+u0),v=floor(.5+v0),w=floor(.5+w0),
		eu=abs(u-u0),ev=abs(v-v0),ew=abs(w-w0),
		dist=max(max(eu,ev),ew);
	if(dist==eu)
		u=w-v;
	else if(dist==ev)
		v=w-u;
	else
		w=u+v;
	gl_FragColor=vec4(vec3(float(u),float(v),float(w))/float(6),1.);
}