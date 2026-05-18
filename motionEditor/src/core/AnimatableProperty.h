#pragma once
#include <vector>
#include <algorithm>
#include <QString>

template<typename T>
struct Keyframe {
    double time = 0.0;
    T value;
};

template<typename T>
class AnimatableProperty {
public:
    T staticValue;
    std::vector<Keyframe<T>> keyframes;

    AnimatableProperty(T defaultValue = T{}) : staticValue(defaultValue) {}

    T evaluate(double time) const {
        if (keyframes.empty()) return staticValue;

        auto it = std::lower_bound(keyframes.begin(), keyframes.end(), time,
            [](const Keyframe<T>& k, double t) { return k.time < t; });

        if (it == keyframes.begin()) return it->value;
        if (it == keyframes.end()) return (it - 1)->value;

        // Linear interpolation
        const auto& k1 = *(it - 1);
        const auto& k2 = *it;
        double factor = (time - k1.time) / (k2.time - k1.time);
        return lerp(k1.value, k2.value, factor);
    }

    void setStatic(T value) { staticValue = value; keyframes.clear(); }
    void setKeyframe(double time, T value) {
        auto it = std::lower_bound(keyframes.begin(), keyframes.end(), time,
            [](const Keyframe<T>& k, double t) { return k.time < t; });
        
        if (it != keyframes.end() && it->time == time) {
            it->value = value;
        } else {
            keyframes.insert(it, {time, value});
        }
    }

private:
    T lerp(const T& a, const T& b, double f) const {
        return a + (b - a) * f;
    }
};

// Specialization for QString (stepped interpolation)
template<>
inline QString AnimatableProperty<QString>::lerp(const QString& a, const QString& b, double f) const {
    return f < 0.5 ? a : b;
}
