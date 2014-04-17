#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform sampler2D backbuffer;

varying vec2 surfacePosition;

vec4 color;

vec4 getVal(vec2 pos)
{
	return texture2D(backbuffer,pos/resolution);
}

void setVal(vec2 p,vec4 bt,vec4 d)
{
	if((p.x >= bt.x && p.y >= bt.y)&&(p.x <= bt.z && p.y <= bt.w))
	{
		color = d;
	}
}
//from #3947.0
vec4 line(vec2 point0, vec2 point1,vec2 co){
	vec2 p0 = point0;
	vec2 p1 = point1;
	
	vec2 d = normalize(p1.xy - p0.xy);
	float slen = distance(p0.xy, p1.xy);
	
	float 	d0 = max(abs(dot(co - p0.xy, d.yx * vec2(-1.0, 1.0))), 0.0),
		d1 = max(abs(dot(co - p0.xy, d) - slen * 0.5) - slen * 0.5, 0.0);
	
	float value = step(length(vec2(d0, d1)),0.0025);
	
	vec4 color = vec4(vec3(value), 1.0);
	
	color *= vec4(1.0);
	
	return color;
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy);
	
	vec2 lm = getVal(vec2(1.0,1.0)).xy*resolution;
	
	color = texture2D(backbuffer,p/resolution);
	
	color += vec4(line(mouse,lm/resolution,p/resolution));
	
	//if(atVal(p,vec4(0.,0.,2.,2.)))
	//{
	//	color = vec4(mouse.x,mouse.y,0.0,0.0);
	//}
	setVal(p,vec4(0.,0.,2.,2.),vec4(mouse.x,mouse.y,0.,0.));
	
	
	gl_FragColor = vec4( vec3( color), 1.0 );

}