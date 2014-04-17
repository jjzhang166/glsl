#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 rect(vec2 pos, vec2 size, vec3 color, vec3 original)
{
    vec2 pixel = gl_FragCoord.xy;
    if (pixel.x >= pos.x && pixel.x < pos.x + size.x && pixel.y >= pos.y && pixel.y < pos.y + size.y)
    	return color;
    else
	return original;
}

vec3 sphere(vec2 pos,float radius, vec3 color, vec3 original)
{
    vec2 pixel = gl_FragCoord.xy;
    vec2 point = pos;
	
    float x = radius - distance(pixel.xy, point.xy);
    if (x < 0.0) {
        return original;
    } else {
        return color;
    }
}

void main()
{
    vec2 r = resolution;

    vec2 position = mouse;
	
    vec3 color = vec3(0);

    vec3 skin_color = vec3(sin(time*1.2)*sin(time*1.2)+.2,cos(time*1.1)*cos(time*1.1)+.2,sin(time*3.2+180.)*sin(time*3.2+180.)+.2);
	
    color = sphere(vec2(mouse.x*r.x-(r.x*0.055),r.y*mouse.y-(r.y*0.15)),.06*r.x,skin_color,color);
    color = sphere(vec2(mouse.x*r.x+(r.x*0.055),r.y*mouse.y-(r.y*0.15)),.06*r.x,skin_color,color);
    color = rect(vec2(mouse.x*r.x-(r.x*0.05),r.y*mouse.y-(r.y*0.15)),vec2(r.x*0.1,r.y*.5),skin_color,color);
    color = sphere(vec2(mouse.x*r.x,r.y*mouse.y+(r.y*0.35)),.06*r.x,skin_color,color);
    

    gl_FragColor = vec4(color, 1.0);
}