// rotwang: @mod* little variation

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float speed = time*0.25;
	vec2 position = ( (gl_FragCoord.xy - resolution.xy*0.5) / resolution.x );
	vec2 center1 = vec2(sin(speed), cos(speed*0.535))*0.3;
	vec2 center2 = vec2(sin(speed*0.259), cos(speed*0.605))*0.4;
	vec2 center3 = vec2(sin(speed*0.346), sin(speed*0.263))*0.3;
	float size = 90.0; // (sin(time*0.1)+1.2)*30.0;
	vec2 color = vec2(0.);
	float d = distance(position, center1)*size;
	color += vec2(cos(d),sin(d));
	d = distance(position, center2)*size;
	color += vec2(cos(d),sin(d));
	d = distance(position, center3)*size;
	color += vec2(cos(d),sin(d));
	vec2 ncolor = normalize(color);
	
	vec3 clr = vec3(ncolor.x,ncolor.y,-ncolor.x-ncolor.y);
	clr *= sqrt(color.x*color.x+color.y*color.y)*0.25;
	gl_FragColor = vec4(clr, 1.0 );

}