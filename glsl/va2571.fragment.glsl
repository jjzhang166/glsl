#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float distTo(vec2 p1, vec2 p2){
	float dx = p1.x - p2.x;
	float dy = p1.y - p2.y;
	float dt = sqrt(dx*dx + dy*dy);
	return dt;
}

void main( void ) {
	
	vec2 oc = gl_FragCoord.xy;
	vec2 uv = (oc.xy / resolution.xy);
	float r = 0.0;
	float g = 0.0;
	float b = 0.0;
	float tfac = time*0.1;
	float ballSize = 0.04 + (sin(time)+1.0)*0.03;
	
	for(float t = 1.0; t < 3.0; t++){
		for(float k = 1.0; k <21.0; k++){
			if(t==0.0 && k > 1.0){
				break;
			}
			float len = t*(0.19*(1.0 + sin(time*cos(k)+k)*0.5))*resolution.x;
			float x = cos((k*tfac*(time)*0.01)*36.0*3.14/180.0)*len + resolution.x*0.5;
			float y = sin((k*tfac*time*0.01)*36.0*3.14/180.0)*len + resolution.y*0.5;
			vec2 p = vec2(x,y);
			
			float dist = distTo(p,oc);
			
			float sizeMod = (sin(time*k*0.01)+1.0)*0.01;
			if(dist/resolution.x < ballSize+ sizeMod ){
				g += 1.0 - (dist/resolution.x)/(ballSize+sizeMod);
				
			}
			sizeMod += (cos(time*k*0.03)+1.1)*0.05;
			if(dist/resolution.x < ballSize+ sizeMod ){
				r += 1.0 - (dist/resolution.x)/(ballSize+sizeMod);
				
			}
			sizeMod -= (sin(time*k*0.03)+1.1)*0.02;
			if(dist/resolution.x < ballSize+ sizeMod ){
				b += 1.0 - (dist/resolution.x)/(ballSize+sizeMod);
				
			}
			b += (dist/resolution.x)/(2.0*21.0);
			g += (dist/resolution.x)/(2.0*21.0);
			
		}
	}

	vec3 rgb = vec3(r,g,b);
	gl_FragColor = vec4( rgb, 1.0 );

}

