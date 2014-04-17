#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


vec3 _scale = vec3(1.0);
vec3 _position = vec3(0.0);
vec4 _color = vec4(1.0);
float _lineWidth = 0.002;

// unormalize and shift coordinates to the center
vec4 frag;
vec2 coord = (gl_FragCoord.xy / resolution.y - vec2((resolution.x/resolution.y)/2.0, 0.5)) * vec2(2); 


/**
* Projects a 3D point intto 2D space
* and store computed depth into z component.
* Applies current _scale and _position. 
**/
vec3 computePoint(vec3 point){
	point += _position;
	point *= _scale;
	point.z = point.z + 1.0;
	point.xy *= point.z;
	return point;
}
	
vec4 line(vec3 point0, vec3 point1){
	vec3 p0 = computePoint(point0);
	vec3 p1 = computePoint(point1);
	
	
	vec2 d = normalize(p1.xy - p0.xy);
	float slen = distance(p0.xy, p1.xy);
	
	float 	d0 = max(abs(dot(coord - p0.xy, d.yx * vec2(-1.0, 1.0))), 0.0),
		d1 = max(abs(dot(coord - p0.xy, d) - slen * 0.5) - slen * 0.5, 0.0);
	
	float value = step(length(vec2(d0, d1)),_lineWidth);
	
	vec4 color = vec4(vec3(value), 1.0);
	
	color *= _color;
	
	return color;
}

vec4 cube(){
	vec4 color;
	color += line(vec3(-0.5,0.5,-0.5), vec3(0.5,0.5,-0.5));
	color += line(vec3(0.5,0.5,-0.5), vec3(0.5,-0.5,-0.5));
	color += line(vec3(0.5,-0.5,-0.5), vec3(-0.5,-0.5,-0.5));
	color += line(vec3(-0.5,-0.5,-0.5), vec3(-0.5,0.5,-0.5));
	
	color += line(vec3(-0.5,0.5,0.5), vec3(0.5,0.5,0.5));
	color += line(vec3(0.5,0.5,0.5), vec3(0.5,-0.5,0.5));
	color += line(vec3(0.5,-0.5,0.5), vec3(-0.5,-0.5,0.5));
	color += line(vec3(-0.5,-0.5,0.5), vec3(-0.5,0.5,0.5));
	
	color += line(vec3(-0.5,0.5,-0.5), vec3(-0.5,0.5,0.5));
	color += line(vec3(0.5,0.5,-0.5), vec3(0.5,0.5,0.5));
	color += line(vec3(0.5,-0.5,-0.5), vec3(0.5,-0.5,0.5));
	color += line(vec3(-0.5,-0.5,-0.5), vec3(-0.5,-0.5,0.5));
	
	return color;
}
void main( void ) {
	frag += cube();
	
	gl_FragColor = frag;
}