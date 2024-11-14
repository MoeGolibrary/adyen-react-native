import React, {useCallback, useState} from 'react';
import {
  Button,
  SafeAreaView,
  TextInput,
  Text,
  View,
  Alert,
  useColorScheme,
  requireNativeComponent,
} from 'react-native';
import {AdyenAction} from '@adyen/react-native';
import Styles from '../Utilities/Styles';
import {useAppContext} from '../Utilities/AppContext';
import {isSuccess} from '../Utilities/Helpers';
import {payWithCard} from '../Utilities/payWithCard';

const CardView = requireNativeComponent('AdyenCardView');

const CseView = ({navigation}) => {
  const isDarkMode = useColorScheme() === 'dark';

  const [cardHeight, setCardHeight] = useState(0);

  const {configuration} = useAppContext();

  const [number, setNumber] = useState('');
  const [expiryMonth, setExpiryMonth] = useState('');
  const [expiryYear, setExpiryYear] = useState('');
  const [cvv, setCvv] = useState('');

  const handleHeightChange = (event) => {
    const { height } = event.nativeEvent;
    console.log("New card height: ", height);  // 输出新的高度值
    setCardHeight(height);  // 更新状态
  };

  const handleDataChange = (event) => {
    const { isValid, data } = event.nativeEvent;
    console.log(`New card isValid: ${isValid}, data: ${JSON.stringify(data)}`, ); 
  };

  const tryEncryptCard = useCallback(async () => {
    const unencryptedCard = {
      number,
      expiryMonth,
      expiryYear,
      cvv,
    };
    try {
      const result = await payWithCard(unencryptedCard, configuration);
      handleResult(navigation, result);
    } catch (e) {
      AdyenAction.hide(isSuccess(false));
      Alert.alert('Error', e.message);
    }
  }, [configuration, cvv, expiryMonth, expiryYear, navigation, number]);

  function handleResult(navigation, result) {
    AdyenAction.hide(isSuccess(result.resultCode));
    navigation.popToTop();
    navigation.push('Result', {result: result.resultCode});
  }

  return (
    <SafeAreaView style={Styles.page}>
      <View style={Styles.centeredContent}>
        <TextInput
          style={isDarkMode ? Styles.textInputDark : Styles.textInputLight}
          inputMode={'numeric'}
          placeholder={'1234 5678 9012 3456'}
          maxLength={19}
          onChangeText={setNumber}
        />
        <View style={Styles.horizontalContent}>
          <View style={Styles.horizontalContent}>
            <TextInput
              style={isDarkMode ? Styles.textInputDark : Styles.textInputLight}
              inputMode={'numeric'}
              placeholder="MM"
              maxLength={2}
              onChangeText={setExpiryMonth}
            />
            <Text
              style={[
                isDarkMode ? Styles.textDark : Styles.textLight,
                Styles.slash,
              ]}>{`/`}</Text>
            <TextInput
              style={isDarkMode ? Styles.textInputDark : Styles.textInputLight}
              inputMode={'numeric'}
              placeholder="YYYY"
              maxLength={4}
              onChangeText={setExpiryYear}
            />
          </View>
          <TextInput
            style={isDarkMode ? Styles.textInputDark : Styles.textInputLight}
            inputMode={'numeric'}
            placeholder="123"
            maxLength={4}
            onChangeText={setCvv}
          />
        </View>

        <CardView style={{ width: '100%', height: cardHeight }} 
          backgroundColor='white' 
          config={ {
            baseURL : 'https://checkoutshopper-test.adyen.com/',
            clientKey : 'local_DUMMYKEYFORTESTING'
          } }
          onHeightChange={handleHeightChange} 
          onDataChange={handleDataChange}
        />

        <Button onPress={() => tryEncryptCard()} title="Pay" />
      </View>
    </SafeAreaView>
  );
};

export default CseView;
