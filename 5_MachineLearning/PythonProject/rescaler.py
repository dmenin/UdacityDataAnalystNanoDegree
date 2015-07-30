import numpy

def featureScaling(arr):
    _min = min(arr)
    _max = max(arr)
    return [(float(x)-_min)/(_max-_min) for x in arr]

    return None

def featureScaling2(arr):
    arr = numpy.array(arr)
    _min = min(arr)
    _max = max(arr)
    return (arr - _min)/float((_max-_min))

# tests of your feature scaler--line below is input data
data = [115, 140, 175]
print featureScaling2(data)

