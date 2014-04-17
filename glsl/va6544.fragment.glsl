// rotwang: @mod* little variation
// modified by @hintz

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(void) 
{
	float speed = time*0.25;
	vec2 position = ( (gl_FragCoord.xy - resolution.xy*0.5) / resolution.x );
	vec2 center1 = vec2(cos(speed), cos(speed*0.535));
	vec2 center2 = vec2(cos(speed*0.259), cos(speed*0.605));
	vec2 center3 = vec2(cos(speed*0.346), cos(speed*0.263));
	vec2 center4 = vec2(cos(speed*0.1346), cos(speed*0.1263));
	float size = (sin(time*0.1)+1.2)*64.0;
	float d = distance(position, center1)*size;
	vec2 color = vec2(cos(d),sin(d));
	d = distance(position, center2)*size;
	color += vec2(cos(d),sin(d));
	d = distance(position, center3)*size;
	color += vec2(cos(d),sin(d));
	d = distance(position, center4)*size;
	color += vec2(cos(d),sin(d));
	vec2 ncolor = normalize(color);
	
	vec3 clr = vec3(ncolor.x,ncolor.y,-ncolor.x-ncolor.y);
	clr *= sqrt(color.x*color.x+color.y*color.y)*0.25;
	gl_FragColor = vec4(cos(clr*3.0+0.5)+sin(clr*2.0), 1.0 );

}