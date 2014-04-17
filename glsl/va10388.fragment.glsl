#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 1.00;

vec2 rotate(vec2 point, float rads) {
	float cs = cos(rads);
	float sn = sin(rads);
	return point * mat2(cs, -sn, sn, cs);
}


bool star(vec2 p) {
	if (length(p) > 0.5) return false;
	int j = 0;
	for (float i=0.0; i<360.0; i+=72.0)
	{
		vec2 p0 = rotate(p.yx, radians(i));
		if (p0.x > 0.115) j++;
	}

	return j < 2;
}


void main(void) 
{	
	vec2 position = ( gl_FragCoord.xy - resolution.xy * 0.5 ) / length(resolution.xy) * 400.0;
	vec3 color;

	if(length(position.xy-vec2(-104.8,72.0)) < 13.0) 
	{		
		color = vec3(1.0, 0.82, 0.14)*sin(1.3+(length(position.xy-vec2(-104.0,72.0))/8.0));
		gl_FragColor = vec4(color.xyz, 1.0);
	}
		
	else if(position.x < -100.0 && position.x > -110.0&& position.y > -100.0 && position.y <65.0)
	{

		float pos = position.y * (86.0/53.0);
		
		color = vec3(1.0, 0.8, 0.6)-0.7*sin(position.x*0.10)-0.7*sin(0.70+position.x*0.5);
		gl_FragColor = vec4(color.xyz, 1.0);
	}
	else
	{
		float band = 120.0 / 13.0;
		position.y += sin(position.x * 0.1 - time) * 2.0;
		float pos = position.y * (86.0/53.0);
		
		if(abs(position.x) < 100.0 && position.y > 60.0 - band * 7.0 && position.y <60.0) 
		{
			if (position.x < -20.0)
			{
				bool is_star = false;
				for(float i=0.0; i<9.0; i++)
				{
					for(float j=0.0; j<6.0; j++)
					{
						if (j==1.0) break;
						is_star = star((position-vec2(-130.0+(1.0+j+0.5)*90.0/2.0, 36.0-band+(0.1)*60.0/9.0))/69.0);
						if (is_star) break;
					}
					if (is_star) break;
				}
				if (is_star)
					color = vec3(1.2, 1.2, 1.2);
				else
					color = vec3(0, 0, 1.2);
				//color = vec3(0, 0, 1.2);
			}
			else
			{
				int nBand = int((position.y + 60.0)/ band) - 6;
				if (nBand == 0 || nBand == 2 || nBand == 4 || nBand == 6)
				{
					color = vec3(1.2, 1.2, 1.2);
				}
				else
				{
					color = vec3(1.2, 1.2, 1.2);
				}
			}
		}
		else if(abs(position.x) < 100.0 && position.y < 0.0 && position.y> -60.0)
		{
			int nBand = int((position.y + 60.0)/ band);
			if (nBand == 1 || nBand == 3 || nBand == 5)
			{
				color = vec3(1.2, 0, 0);
			}
			else
			{
				color = vec3(1.2, 0.0, 0.0);
			}
		}
			
		gl_FragColor = vec4(color * (-cos(position.x * 0.1 - time) * 0.3 + 0.7), 1.);
	}
}