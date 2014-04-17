// power-2 mandelbulb looks like shit

// based on simple Mandlebulb by Xavier de Boysson 

// http://blog.hvidtfeldts.net/index.php/2011/09/distance-estimated-3d-fractals-v-the-mandelbulb-different-de-approximations/
// faster distance estimation: http://www.iquilezles.org/www/articles/mandelbulb/mandelbulb.htm


precision highp float;
#define PI 3.141592653589793

#define ZOOM (4. - sin(time/2.)*3.)

#define MAX_ITERATION 30
#define ITERATION_BAIL 2.

#define MAX_MARCH 1000
#define MAX_DISTANCE 4.

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float DE(vec3 p)
{
	vec3 w = p;
	float dr = 1.;
	float r = 0.;
	for (int i=0; i<MAX_ITERATION; ++i)
	{
		r = length(w);
		if (r>ITERATION_BAIL) break;
		
		dr*= r*2.+1.;
		
	float dwxz = dot(w.xz,w.xz);
	float cos2wo = dwxz-w.y*w.y;
	float sin2wo = w.y*sqrt(dwxz)*2.;
	float sin2wi = w.x*w.z/dwxz*2.;
	float cos2wi = w.z*w.z/dwxz*2.-1.;
  	w = vec3(cos2wo*sin2wi, sin2wo, cos2wo*cos2wi);
		
		w+=p;
	} 
	return  max(.5*log(r)*r/dr,p.y);
}

bool inCircle(vec3 p, vec3 d)
{
	float rdt = dot(p, d);
	float rdr = dot(p, p) - 1.253314137315501; // sqrt(PI/2)
	return (rdt*rdt)-rdr>0.;	
}



void main( void )
{
	vec2 pos = (gl_FragCoord.xy*2.0 - resolution.xy) / resolution.y;
	
	vec2 m = vec2(sin(time), cos(time))/ZOOM;
	//m = ((.5-mouse)*PI*2.)/ZOOM;
	m.y = clamp(m.y, -PI/2.+.01, PI/2.-.01);
	
	vec3 camOrigin = vec3(cos(m.x)*cos(m.y), sin(m.y), cos(m.y)*sin(m.x))*2.0;
	vec3 camTarget = vec3(0.0, 0.0, 0.0);
	vec3 camDir = normalize(camTarget - camOrigin);
	vec3 camUp  = normalize(vec3(0.0, 1.0, 0.0));
	vec3 camSide = normalize(cross(camDir, camUp));
	vec3 camCDS = cross(camDir, camSide);
	
	vec3 ray = normalize(camSide*pos.x + camCDS*pos.y + camDir*ZOOM);
	
	float col = 0., col2 = 0., col3 = 0.;
	if (inCircle(camOrigin, ray))
	{
		float m = 1.0, dist = 0.0, total_dist = 0.0;

		for(int i=0; i<MAX_MARCH; ++i)
		{
			total_dist += dist;
			dist = DE(camOrigin + ray * total_dist);
			m -= 1./float(MAX_MARCH);
			if(dist<0.0002/ZOOM || total_dist>MAX_DISTANCE) break;
		}
		
		col = m;
		col2 = m*2.5-total_dist;
		col3 = m*1.5-total_dist;
		if (total_dist>MAX_DISTANCE) col = 0.;
	}	

	gl_FragColor = vec4(col, col2/2., col3*2., 1.0);
}
