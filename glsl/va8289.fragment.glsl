// rotwang: @mod* little variation
// modified by @hintz
// slow and close mod by kapsy1312.tumblr.com

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(void) 
{
	float speed = time*0.0000001;
	vec2 position = ( (gl_FragCoord.xy - resolution.xy*0.1) / resolution.x );
	vec2 center1 = vec2(cos(speed), cos(speed*0.000535));
	vec2 center2 = vec2(cos(speed*0.259), cos(speed*0.00605));
	vec2 center3 = vec2(-cos(speed*0.746), cos(speed*0.0263));
	vec2 center4 = vec2(cos(speed*0.1346), cos(speed*0.01263));
	float size = (sin(time*0.061)+1.2)*4.0;
	float d = distance(position, center1)*size;
	vec2 color = vec2(cos(d),sin(d));
	d = distance(position, center2)*size;
	color += vec2(cos(d),sin(d));
	d = distance(position, center3)*size;
	color *= vec2(cos(d),sin(d));
	d = distance(position, center4)*size;
	color += vec2(cos(d),sin(d));
	vec2 ncolor = normalize(color);
	
	vec3 clr = vec3(ncolor.x,ncolor.y,-ncolor.x-ncolor.y);
	clr *= sqrt(color.x*color.x+color.y*color.y)*0.25;
	gl_FragColor = vec4(cos(clr*3.0+0.5)+sin(clr*2.0), 1.0 );

}