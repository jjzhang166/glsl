#ifdef GL_ES
precision highp float;
#endif


uniform vec2 resolution;
uniform float time;

// just some raymarching in 2d


float scene( vec2 pos  )
{
	
    	float c = length(pos) - 0.1;
    	return c;
}

vec2 trace(vec2 ro, vec2 rd, out bool hit)
{
    const int maxSteps = 50;
    const float hitThreshold = 0.01;
    hit = false;
    vec2 pos = ro;

    for(int i=0; i<maxSteps; i++)
    {
        float d = abs(scene(pos));
        if (d < hitThreshold) {
            hit = true;
            return pos;
        }
        pos += d*rd;
    }
    return pos;
}


vec3 scene_color( vec2 pos  )
{
	
    	float c = abs(scene(pos));
	vec3 color = c < 0.003 ? vec3( 1.0, 0.2, 0.2 ) : vec3( sqrt(c) );
	
	bool hit;
	vec2 point = trace( vec2(-0.16, 0.), vec2( 0.5, 0.0 ), hit);
	//* vec2(0.3, 0);*/
	//if( hit )
	color = length( pos - point ) < 0.01 ? vec3( 0.2, 1.0, 0.2 ) : color;
	
    	return color;
}

void main(void)
{
    vec2 p = (-1.0+2.0*gl_FragCoord.xy/resolution.xy);

    vec3 col = scene_color(vec2(0.0+2.0*p.x,0.0+2.0*p.y*(resolution.y/resolution.x)));
    gl_FragColor = vec4(col,1.0);

}
